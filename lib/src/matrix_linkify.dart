import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linkfy_text/src/enum.dart';
import 'package:linkfy_text/src/model/link.dart';
import 'package:linkfy_text/src/utils/matrix_regex.dart';

/// Matrix Linkify [text] containing urls, emails or hashtag
class MatrixLinkifyText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;
  final TextAlign? textAlign;
  final List<LinkType>? linkTypes;
  final ThemeData? themeData;
  final Function(Link)? onTapLink;
  final Function(TapDownDetails, Link)? onTapDownLink;
  final int? maxLines;

  const MatrixLinkifyText({
    Key? key,
    required this.text,
    this.textStyle,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.linkTypes,
    this.themeData,
    this.onTapLink,
    this.onTapDownLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CleanRichText(
      LinkifyTextSpans(
        text: text,
        textStyle: textStyle,
        linkStyle: linkStyle,
        linkTypes: linkTypes,
        themeData: themeData,
        onTapLink: onTapLink,
        onTapDownLink: onTapDownLink,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

/// Like Text.rich only that it also correctly disposes of all recognizers
class CleanRichText extends StatefulWidget {
  final InlineSpan child;
  final TextAlign? textAlign;
  final int? maxLines;

  const CleanRichText(this.child, {Key? key, this.textAlign, this.maxLines})
      : super(key: key);

  @override
  State<CleanRichText> createState() => _CleanRichTextState();
}

class _CleanRichTextState extends State<CleanRichText> {
  void _disposeTextspan(TextSpan textSpan) {
    textSpan.recognizer?.dispose();
    if (textSpan.children != null) {
      for (final child in textSpan.children!) {
        if (child is TextSpan) {
          _disposeTextspan(child);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.child is TextSpan) {
      _disposeTextspan(widget.child as TextSpan);
    }
  }

  @override
  Widget build(BuildContext build) {
    return Text.rich(
      widget.child,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
    );
  }
}

class LinkTextSpan extends TextSpan {
  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.
  final Link link;
  final void Function(TapDownDetails, Link)? onTapDownLink;
  final void Function(Link)? onTapLink;

  LinkTextSpan({
    TextStyle? style,
    required this.link,
    String? text,
    this.onTapDownLink,
    this.onTapLink,
    List<InlineSpan>? children,
  }) : super(
          style: style,
          text: text ?? '',
          children: children ?? <InlineSpan>[],
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (onTapLink != null) {
                onTapLink(link);
              }
            }
            ..onTapDown = (details) async {
              if (onTapDownLink != null) {
                onTapDownLink(details, link);
                return;
              }
            },
        ) {
    _fixRecognizer(this, recognizer!);
  }

  void _fixRecognizer(TextSpan textSpan, GestureRecognizer recognizer) {
    if (textSpan.children?.isEmpty ?? true) {
      return;
    }
    final fixedChildren = <InlineSpan>[];
    for (final child in textSpan.children!) {
      if (child is TextSpan && child.recognizer == null) {
        _fixRecognizer(child, recognizer);
        fixedChildren.add(TextSpan(
          text: child.text,
          style: child.style,
          recognizer: recognizer,
          children: child.children,
        ));
      } else {
        fixedChildren.add(child);
      }
    }
    textSpan.children!.clear();
    textSpan.children!.addAll(fixedChildren);
  }
}

// ignore: non_constant_identifier_names
TextSpan LinkifyTextSpans({
  String text = '',
  TextStyle? linkStyle,
  TextStyle? textStyle,
  List<LinkType>? linkTypes,
  Map<LinkType, TextStyle>? customLinkStyles,
  ThemeData? themeData,
  Function(Link)? onTapLink,
  Function(TapDownDetails, Link)? onTapDownLink,
}) {
  textStyle ??= themeData?.textTheme.bodyMedium;
  linkStyle ??= themeData?.textTheme.bodyMedium?.copyWith(
    color: themeData.colorScheme.secondary,
    decoration: TextDecoration.underline,
  );

  final regExp = constructMatrixRegExpFromLinkType(linkTypes ?? [LinkType.url]);

  //  return the full text if there's no match or if empty
  if (!regExp.hasMatch(text) || text.isEmpty) {
    return TextSpan(
      text: text,
      style: textStyle,
      children: const [],
    );
  }

  final texts = text.split(regExp);
  final List<InlineSpan> spans = [];
  final highlights = regExp.allMatches(text).toList();

  for (final text in texts) {
    spans.add(TextSpan(
      text: text,
      style: textStyle,
      children: const [],
    ));

    if (highlights.isNotEmpty) {
      final match = highlights.removeAt(0);
      final link = Link.fromTwakeMatch(match);
      if (link.type == null) {
        spans.add(TextSpan(
          text: link.value,
          style: textStyle,
          children: const [],
        ));
        continue;
      }
      // add the link
      spans.add(
        LinkTextSpan(
          text: link.value,
          link: link,
          style: customLinkStyles?[link.type] ?? linkStyle,
          onTapLink: onTapLink,
          onTapDownLink: onTapDownLink,
        ),
      );
    }
  }
  return TextSpan(children: spans);
}

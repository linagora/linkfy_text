import 'package:linkfy_text/src/enum.dart';
import 'package:linkfy_text/src/utils/matrix_regex.dart';
import 'package:linkfy_text/src/utils/regex.dart';

class Link {
  late final String? _value;
  late final LinkType? _type;

  String? get value => _value;

  LinkType? get type => _type;

  /// construct link from matched regExp
  Link.fromMatch(RegExpMatch match) {
    final String matchString = match.input.substring(match.start, match.end);
    _type = getMatchedType(matchString);
    _value = matchString;
  }

  /// construct link from matched Twake regExp
  Link.fromTwakeMatch(RegExpMatch match) {
    final String matchString = match.input.substring(match.start, match.end);
    _type = getMatrixMatchedType(matchString);
    _value = matchString;
  }

  Link.parse({
    required String value,
    required LinkType type,
  }) {
    _value = value;
    _type = type;
  }
}

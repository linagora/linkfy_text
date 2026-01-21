import 'package:linkfy_text/src/enum.dart';
import 'package:linkfy_text/src/utils/matrix_contants.dart';

/// construct matrix regexp. pattern from provided link types
RegExp constructMatrixRegExpFromLinkType(List<LinkType> types) {
  RegExp regexToUse;
  try {
    RegExp(MatrixConstants.matrixRegex).hasMatch('');
    regexToUse = RegExp(MatrixConstants.matrixRegex);
  } catch (_) {
    regexToUse = RegExp(MatrixConstants.fallbackRegex);
  }

  // default case where we always want to match url strings
  final len = types.length;
  if (len == 1 && types.first == LinkType.url) {
    return regexToUse;
  }
  final buffer = StringBuffer();
  for (var i = 0; i < len; i++) {
    final type = types[i];
    final isLast = i == len - 1;
    switch (type) {
      case LinkType.url:
        isLast
            ? buffer.write("(${regexToUse.pattern})|(${MatrixConstants.urlRegExp})")
            : buffer.write("(${regexToUse.pattern})|(${MatrixConstants.urlRegExp})|");
        break;
      case LinkType.hashTag:
        isLast
            ? buffer
                .write("(${regexToUse.pattern})|(${MatrixConstants.hashtagRegExp})")
            : buffer
                .write("(${regexToUse.pattern})|(${MatrixConstants.hashtagRegExp})|");
        break;
      case LinkType.userTag:
        isLast
            ? buffer
                .write("(${regexToUse.pattern})|(${MatrixConstants.userTagRegExp})")
            : buffer
                .write("(${regexToUse.pattern})|(${MatrixConstants.userTagRegExp})|");
        break;
      case LinkType.email:
        isLast
            ? buffer.write("(${regexToUse.pattern})|(${MatrixConstants.emailRegExp})")
            : buffer
                .write("(${regexToUse.pattern})|(${MatrixConstants.emailRegExp})|");
        break;
      case LinkType.phone:
        isLast
            ? buffer.write("(${MatrixConstants.phoneRegExp})")
            : buffer.write("(${MatrixConstants.phoneRegExp})|");
        break;
      default:
    }
  }
  return RegExp(buffer.toString());
}

LinkType? getMatrixMatchedType(String match) {
  if (RegExp(MatrixConstants.emailRegExp).hasMatch(match)) {
    return LinkType.email;
  } else if (RegExp(MatrixConstants.urlRegExp).hasMatch(match)) {
    return LinkType.url;
  } else if (MatrixConstants.isValidDate(match)) {
    return null;
  } else if (MatrixConstants.isValidPhoneNumber(match)) {
    return LinkType.phone;
  } else if (RegExp(MatrixConstants.userTagRegExp).hasMatch(match)) {
    return LinkType.userTag;
  } else if (RegExp(MatrixConstants.hashtagRegExp).hasMatch(match)) {
    return LinkType.hashTag;
  }
  return null;
}

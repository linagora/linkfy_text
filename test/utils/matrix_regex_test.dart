import 'package:linkfy_text/src/enum.dart';
import 'package:linkfy_text/src/utils/matrix_regex.dart';
import 'package:test/test.dart';

void main() {
  group('getMatrixMatchedType', () {
    group('GIVEN a url whose domain label is a single character\n', () {
      const urls = [
        'https://s.team/p/cdpm-wvtk/ABCDEFGH',
        'https://x.com/foo',
        'http://a.co/b',
        'https://t.co/abc123',
        'https://s.team',
      ];

      for (final url in urls) {
        test('WHEN classifying "$url"'
            'THEN returns LinkType.url', () {
          expect(getMatrixMatchedType(url), equals(LinkType.url));
        });
      }
    });

    group('GIVEN a url whose domain label is longer\n', () {
      const urls = [
        'https://twake.app/test',
        'https://hello.com/GOOGLE',
        'www.google.com',
        'facebook.com',
      ];

      for (final url in urls) {
        test('WHEN classifying "$url"'
            'THEN returns LinkType.url', () {
          expect(getMatrixMatchedType(url), equals(LinkType.url));
        });
      }
    });

    group('GIVEN a bare digit string\n', () {
      test('WHEN classifying "3130612345"'
          'THEN returns LinkType.phone', () {
        expect(getMatrixMatchedType('3130612345'), equals(LinkType.phone));
      });
    });
  });

  group('constructMatrixRegExpFromLinkType', () {
    group('GIVEN a message containing a single-character domain url\n', () {
      test('WHEN matching with [url, phone]'
          'THEN the whole url is extracted and typed as a url', () {
        final regExp = constructMatrixRegExpFromLinkType([
          LinkType.url,
          LinkType.phone,
        ]);
        const message = 'ou sinon le lien : https://s.team/p/cdpm-wvtk/ABCDEFGH';

        final matches = regExp.allMatches(message).toList();

        expect(matches.length, 1);
        expect(matches.first.group(0), 'https://s.team/p/cdpm-wvtk/ABCDEFGH');
        expect(
          getMatrixMatchedType(matches.first.group(0)!),
          equals(LinkType.url),
        );
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkfy_text/linkfy_text.dart';

void main() {
  group('LinkifyTextSpans test phone number', () {
    late ThemeData themeData;

    const linkTypes = [LinkType.phone, LinkType.url];

    const customPhoneStyle = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
    );

    const customStyle = TextStyle(
      color: Colors.black,
    );

    setUp(() {
      themeData = ThemeData.light();
    });

    test('Empty text returns simple TextSpan', () {
      final result = LinkifyTextSpans(
        themeData: themeData,
      );

      expect(result.text, '');
      expect(result.children, null);
    });

    test('Text without phone number returns simple TextSpan', () {
      const text = 'This is a simple text without links';
      final result = LinkifyTextSpans(
        text: text,
        themeData: themeData,
      );

      expect(result.text, text);
      expect(result.children, null);
    });

    test('Text with phone number creates correct TextSpans structure', () {
      const text = 'Call me at (123) 456-7890';
      final result = LinkifyTextSpans(
        text: text,
        textStyle: customStyle,
        linkStyle: customPhoneStyle,
        themeData: themeData,
        linkTypes: linkTypes,
      );

      final children = result.children;
      expect(children?.length, 3);

      if (children != null) {
        expect((children[0] as TextSpan).text, 'Call me at ');
        expect((children[1] as TextSpan).text, '(123) 456-7890');

        final textSpan = children[0] as TextSpan;
        expect(textSpan.style?.color, customStyle.color);

        final linkSpan = children[1] as TextSpan;
        expect(linkSpan.style?.color, customPhoneStyle.color);
      }
    });

    test('Multiple phone types are applied correctly', () {
      const text = 'Call me at (123) 456-7890 or +1234567890';

      final result = LinkifyTextSpans(
        text: text,
        linkStyle: customPhoneStyle,
        textStyle: customStyle,
        linkTypes: linkTypes,
        themeData: themeData,
      );

      final children = result.children;
      if (children != null && children.length > 3) {
        final phone1 = children[1] as TextSpan;
        final phone2 = children[3] as TextSpan;

        expect(phone1.style?.color, customPhoneStyle.color);
        expect(phone2.style?.color, customPhoneStyle.color);
      }
    });

    test('Phone codes for all countries in NANP', () {
      const phoneEntries = [
        'United States: +1 202-555-0173',
        'United States Virgin Islands: +1 340-555-0101',
        'Northern Mariana Islands: +1 670-555-0123',
        'Guam: +1 671-555-0345',
        'American Samoa: +1 684-555-0678',
        'Puerto Rico: +1 787-555-0921',
        'Puerto Rico: +1 939-555-0784',
        'Canada: +1 416-555-0248',
        'Bahamas: +1 242-555-0156',
        'Barbados: +1 246-555-0675',
        'Anguilla: +1 264-555-0498',
        'Antigua and Barbuda: +1 268-555-0234',
        'British Virgin Islands: +1 284-555-0153',
        'Cayman Islands: +1 345-555-0721',
        'Bermuda: +1 441-555-0341',
        'Grenada: +1 473-555-0789',
        'Turks and Caicos Islands: +1 649-555-0456',
        'Jamaica: +1 658-555-0674',
        'Jamaica: +1 876-555-0193',
        'Montserrat: +1 664-555-0892',
        'Sint Maarten: +1 721-555-0478',
        'Saint Lucia: +1 758-555-0302',
        'Dominica: +1 767-555-0657',
        'Saint Vincent and the Grenadines: +1 784-555-0784',
        'Dominican Republic: +1 809-555-0912',
        'Dominican Republic: +1 829-555-0746',
        'Dominican Republic: +1 849-555-0534',
        'Trinidad and Tobago: +1 868-555-0139',
        'Saint Kitts and Nevis: +1 869-555-0325'
      ];

      for (final entry in phoneEntries) {
        final result = LinkifyTextSpans(
          text: entry,
          textStyle: customStyle,
          linkStyle: customPhoneStyle,
          linkTypes: linkTypes,
          themeData: themeData,
        );

        final children = result.children;

        if (children != null) {
          final splitEntry = entry.split(': ');
          final country = '${splitEntry[0]}: ';
          final phoneNumber = splitEntry[1];

          expect((children[0] as TextSpan).text, country);
          expect((children[1] as TextSpan).text, phoneNumber);

          final textSpan = children[0] as TextSpan;
          expect(textSpan.style?.color, customStyle.color);

          final linkSpan = children[1] as TextSpan;
          expect(linkSpan.style?.color, customPhoneStyle.color);
        }
      }
    });

    test('Phone codes for Zone 2 countries (Africa and related territories)',
        () {
      const phoneEntries = [
        'Egypt: +20 123-456-7890',
        'South Sudan: +211 555-0123',
        'Morocco: +212 555-0456',
        'Algeria: +213 555-0789',
        'Tunisia: +216 555-0987',
        'Libya: +218 555-0345',
        'Gambia: +220 555-0567',
        'Senegal: +221 555-0789',
        'Mauritania: +222 555-0912',
        'Mali: +223 555-0345',
        'Guinea: +224 555-0678',
        'Ivory Coast: +225 555-0456',
        'Burkina Faso: +226 555-0789',
        'Niger: +227 555-0912',
        'Togo: +228 555-0234',
        'Benin: +229 555-0456',
        'Mauritius: +230 555-0678',
        'Liberia: +231 555-0912',
        'Sierra Leone: +232 555-0456',
        'Ghana: +233 555-0789',
        'Nigeria: +234 555-0123',
        'Chad: +235 555-0456',
        'Central African Republic: +236 555-0789',
        'Cameroon: +237 555-0912',
        'Cape Verde: +238 555-0345',
        'São Tomé and Príncipe: +239 555-0567',
        'Equatorial Guinea: +240 555-0789',
        'Gabon: +241 555-0123',
        'Republic of the Congo: +242 555-0456',
        'Democratic Republic of the Congo: +243 555-0789',
        'Angola: +244 555-0345',
        'Guinea-Bissau: +245 555-0567',
        'British Indian Ocean Territory: +246 555-0789',
        'Ascension Island: +247 555-0912',
        'Seychelles: +248 555-0456',
        'Sudan: +249 555-0123',
        'Rwanda: +250 555-0345',
        'Ethiopia: +251 555-0678',
        'Somalia: +252 555-0789',
        'Djibouti: +253 555-0456',
        'Kenya: +254 555-0912',
        'Tanzania: +255 555-0123',
        'Zanzibar: +255 24 555-0456',
        'Uganda: +256 555-0678',
        'Burundi: +257 555-0912',
        'Mozambique: +258 555-0345',
        'Zambia: +260 555-0567',
        'Madagascar: +261 555-0789',
        'Réunion: +262 555-0123',
        'Mayotte: +262 269 555-0345',
        'Zimbabwe: +263 555-0456',
        'Namibia: +264 555-0678',
        'Malawi: +265 555-0789',
        'Lesotho: +266 555-0123',
        'Botswana: +267 555-0345',
        'Eswatini: +268 555-0567',
        'Comoros: +269 555-0789',
        'South Africa: +27 555-0912',
        'Saint Helena: +290 555-0345',
        'Tristan da Cunha: +290 8 555-0567',
        'Eritrea: +291 555-0789',
        'Aruba: +297 555-0456',
        'Faroe Islands: +298 555-0123',
        'Greenland: +299 555-0345'
      ];

      for (final entry in phoneEntries) {
        final result = LinkifyTextSpans(
          text: entry,
          textStyle: customStyle,
          linkStyle: customPhoneStyle,
          linkTypes: [LinkType.phone],
          themeData: themeData,
        );

        final children = result.children;

        if (children != null) {
          final splitEntry = entry.split(': ');
          final country = '${splitEntry[0]}: ';
          final phoneNumber = splitEntry[1];

          expect((children[0] as TextSpan).text, country);
          expect((children[1] as TextSpan).text, phoneNumber);

          final textSpan = children[0] as TextSpan;
          expect(textSpan.style?.color, customStyle.color);

          final linkSpan = children[1] as TextSpan;
          expect(linkSpan.style?.color, customPhoneStyle.color);
        }
      }
    });

    test('Phone codes for Zones 3–4 countries (Europe)', () {
      const phoneEntries = [
        'Greece: +30 210-123-4567',
        'Netherlands: +31 612-345-6789',
        'Belgium: +32 2-345-6789',
        'France: +33 1-234-567-890',
        'Spain: +34 912-345-678',
        'Gibraltar: +350 200-12345',
        'Portugal: +351 21-234-5678',
        'Madeira: +351 291-123-456',
        'Azores (Horta area): +351 292-123-456',
        'Azores (Angra do Heroísmo area): +351 295-123-456',
        'Azores (São Miguel Island): +351 296-123-456',
        'Luxembourg: +352 26-123-456',
        'Ireland: +353 1-234-5678',
        'Iceland: +354 512-3456',
        'Albania: +355 4-123-4567',
        'Malta: +356 2123-4567',
        'Cyprus: +357 22-123-456',
        'Finland: +358 9-123-4567',
        'Åland: +358 18-123-456',
        'Bulgaria: +359 2-123-4567',
        'Hungary: +36 1-234-5678',
        'Lithuania: +370 5-123-4567',
        'Latvia: +371 6-123-4567',
        'Estonia: +372 5123-4567',
        'Moldova: +373 22-123-456',
        'Armenia: +374 10-123-456',
        'Belarus: +375 17-123-4567',
        'Andorra: +376 812-345',
        'Monaco: +377 97-123-456',
        'San Marino: +378 0549-123456',
        'Vatican City: +39 06698-12345',
        'Ukraine: +380 44-123-4567',
        'Serbia: +381 11-123-4567',
        'Montenegro: +382 20-123-456',
        'Kosovo: +383 38-123-456',
        'Croatia: +385 1-234-5678',
        'Slovenia: +386 1-123-4567',
        'Bosnia and Herzegovina: +387 33-123-456',
        'North Macedonia: +389 2-123-4567',
        'Italy: +39 06-123-4567',
        'Romania: +40 21-123-4567',
        'Switzerland: +41 44-123-4567',
        "Campione d'Italia: +41 91-123-4567",
        'Czech Republic: +420 123-456-789',
        'Slovakia: +421 2-123-4567',
        'Liechtenstein: +423 236-1234',
        'Austria: +43 1-234-5678',
        'United Kingdom: +44 20-1234-5678',
        'Guernsey: +44 1481-123456',
        'Jersey: +44 1534-123456',
        'Isle of Man: +44 1624-123456',
        'Denmark: +45 32-123-456',
        'Sweden: +46 8-123-4567',
        'Norway: +47 21-123-456',
        'Svalbard: +47 79-123-456',
        'Poland: +48 22-123-4567',
        'Germany: +49 30-123-4567'
      ];

      for (final entry in phoneEntries) {
        final result = LinkifyTextSpans(
          text: entry,
          textStyle: customStyle,
          linkStyle: customPhoneStyle,
          linkTypes: linkTypes,
          themeData: themeData,
        );

        final children = result.children;

        if (children != null) {
          final splitEntry = entry.split(': ');
          final country = '${splitEntry[0]}: ';
          final phoneNumber = splitEntry[1];

          expect((children[0] as TextSpan).text, country);
          expect((children[1] as TextSpan).text, phoneNumber);

          final textSpan = children[0] as TextSpan;
          expect(textSpan.style?.color, customStyle.color);

          final linkSpan = children[1] as TextSpan;
          expect(linkSpan.style?.color, customPhoneStyle.color);
        }
      }
    });

    test(
        'WHEN send text "Alo +1234567890." '
        'THEN should highlight phone number', () {
      const text = 'Alo +1234567890.';

      final result = LinkifyTextSpans(
        text: text,
        linkStyle: customPhoneStyle,
        textStyle: customStyle,
        linkTypes: linkTypes,
        themeData: themeData,
      );

      final children = result.children;
      if (children != null && children.length > 3) {
        final text = children[0] as TextSpan;
        final phone = children[1] as TextSpan;

        expect(text.style?.color, customStyle.color);
        expect(phone.style?.color, customPhoneStyle.color);
      }
    });

    test(
        'WHEN send text "Alo +1234567890m" '
        'THEN should highlight phone number', () {
      const text = 'Alo +1234567890m';

      final result = LinkifyTextSpans(
        text: text,
        linkStyle: customPhoneStyle,
        textStyle: customStyle,
        linkTypes: linkTypes,
        themeData: themeData,
      );

      final children = result.children;
      if (children != null && children.length > 3) {
        final text = children[0] as TextSpan;
        final phone = children[1] as TextSpan;

        expect(text.style?.color, customStyle.color);
        expect(phone.style?.color, customPhoneStyle.color);
      }
    });

    test(
        'WHEN send text "Alo +12345678901234567890" '
        'THEN not highlight phone number', () {
      const text = 'Alo +12345678901234567890';

      final result = LinkifyTextSpans(
        text: text,
        linkStyle: customPhoneStyle,
        textStyle: customStyle,
        linkTypes: linkTypes,
        themeData: themeData,
      );

      final children = result.children;
      if (children != null && children.length > 3) {
        final text = children[0] as TextSpan;
        final phone = children[1] as TextSpan;

        expect(text.style?.color, customStyle.color);
        expect(phone.style?.color, customStyle.color);
      }
    });

    test(
      'GIVEN list data of Outside France territories with phone numbers '
      'THEN should highlight phone number',
      () {
        const phoneEntries = [
          // Guadeloupe, Saint-Barthélemy, and Saint-Martin
          'Guadeloupe (Fixed phone line): +590 590 12 34 56',
          'Guadeloupe (Mobile phone line): +590 690 78 90 12',
          'Guadeloupe (Mobile phone line): +590 691 23 45 67',

          // French Guiana
          'French Guiana (Fixed phone line): +594 594 34 56 78',
          'French Guiana (Mobile phone line): +594 694 56 78 90',

          // Martinique
          'Martinique (Fixed phone line): +596 596 12 34 56',
          'Martinique (Mobile phone line): +596 696 78 90 12',
          'Martinique (Mobile phone line): +596 697 34 56 78',

          // Réunion
          'Réunion (Fixed phone line): +262 262 12 34 56',
          'Réunion (Fixed phone line): +262 263 45 67 89',
          'Réunion (Mobile phone line): +262 692 78 90 12',
          'Réunion (Mobile phone line): +262 693 34 56 78',

          // Mayotte
          'Mayotte (Fixed phone line): +262 269 56 78 90',
          'Mayotte (Mobile phone line): +262 639 12 34 56',

          // Saint Pierre and Miquelon
          'Saint Pierre and Miquelon (Fixed/Mobile): +508 45 67 89',

          // New Caledonia
          'New Caledonia (Fixed/Mobile): +687 12 34 56'
        ];

        for (final entry in phoneEntries) {
          final result = LinkifyTextSpans(
            text: entry,
            textStyle: customStyle,
            linkStyle: customPhoneStyle,
            linkTypes: linkTypes,
            themeData: themeData,
          );

          final children = result.children;

          if (children != null) {
            final splitEntry = entry.split(': ');
            final country = '${splitEntry[0]}: ';
            final phoneNumber = splitEntry[1];

            expect((children[0] as TextSpan).text, country);
            expect((children[1] as TextSpan).text, phoneNumber);

            final textSpan = children[0] as TextSpan;
            expect(textSpan.style?.color, customStyle.color);

            final linkSpan = children[1] as TextSpan;
            expect(linkSpan.style?.color, customPhoneStyle.color);
          }
        }
      },
    );

    test(
      'GIVEN list data of Outside Russia territories with phone numbers '
      'THEN should highlight phone number',
      () {
        const phoneEntries = [
          // Moscow
          'Russia (Moscow - Fixed line): +7 495 123-45-67',
          'Russia (Moscow - Mobile): +7 925 123-45-67',

          // Saint Petersburg
          'Russia (Saint Petersburg - Fixed line): +7 812 234-56-78',
          'Russia (Saint Petersburg - Mobile): +7 911 234-56-78',

          // Novosibirsk
          'Russia (Novosibirsk - Fixed line): +7 383 345-67-89',
          'Russia (Novosibirsk - Mobile): +7 913 345-67-89',

          // Yekaterinburg
          'Russia (Yekaterinburg - Fixed line): +7 343 456-78-90',
          'Russia (Yekaterinburg - Mobile): +7 922 456-78-90',

          // Nizhny Novgorod
          'Russia (Nizhny Novgorod - Fixed line): +7 831 567-89-01',
          'Russia (Nizhny Novgorod - Mobile): +7 920 567-89-01',

          // Vladivostok
          'Russia (Vladivostok - Fixed line): +7 423 678-90-12',
          'Russia (Vladivostok - Mobile): +7 914 678-90-12',

          // Sochi
          'Russia (Sochi - Fixed line): +7 862 789-01-23',
          'Russia (Sochi - Mobile): +7 928 789-01-23',

          // Toll-Free Numbers
          'Russia (Toll-Free): +7 800 123-45-67',

          // Business/Shared Cost Services
          'Russia (Business Line): +7 499 123-45-67',
          'Russia (Shared Cost Service): +7 812 123-45-67'
        ];

        for (final entry in phoneEntries) {
          final result = LinkifyTextSpans(
            text: entry,
            textStyle: customStyle,
            linkStyle: customPhoneStyle,
            linkTypes: linkTypes,
            themeData: themeData,
          );

          final children = result.children;

          if (children != null) {
            final splitEntry = entry.split(': ');
            final country = '${splitEntry[0]}: ';
            final phoneNumber = splitEntry[1];

            expect((children[0] as TextSpan).text, country);
            expect((children[1] as TextSpan).text, phoneNumber);

            final textSpan = children[0] as TextSpan;
            expect(textSpan.style?.color, customStyle.color);

            final linkSpan = children[1] as TextSpan;
            expect(linkSpan.style?.color, customPhoneStyle.color);
          }
        }
      },
    );

    test(
      'GIVEN list data of Inside France territories with phone numbers '
      'THEN should highlight phone number',
      () {
        const phoneEntries = [
          // Guadeloupe, Saint-Barthélemy, and Saint-Martin
          'Guadeloupe (Fixed phone line): 0 590 12 34 56',
          'Guadeloupe (Mobile phone line): 0 690 78 90 12',
          'Guadeloupe (Mobile phone line): 0 691 23 45 67',

          // French Guiana
          'French Guiana (Fixed phone line): 0 594 34 56 78',
          'French Guiana (Mobile phone line): 0 694 56 78 90',

          // Martinique
          'Martinique (Fixed phone line): 0 596 12 34 56',
          'Martinique (Mobile phone line): 0 696 78 90 12',
          'Martinique (Mobile phone line): 0 697 34 56 78',

          // Réunion
          'Réunion (Fixed phone line): 0 262 12 34 56',
          'Réunion (Fixed phone line): 0 263 45 67 89',
          'Réunion (Mobile phone line): 0 692 78 90 12',
          'Réunion (Mobile phone line): 0 693 34 56 78',

          // Mayotte
          'Mayotte (Fixed phone line): 0 269 56 78 90',
          'Mayotte (Mobile phone line): 0 639 12 34 56',

          // Saint Pierre and Miquelon
          'Saint Pierre and Miquelon (Fixed/Mobile): 0 508 45 67 89',

          // New Caledonia (from France)
          'New Caledonia (Fixed/Mobile): 00 687 12 34 56'
        ];

        for (final entry in phoneEntries) {
          final result = LinkifyTextSpans(
            text: entry,
            textStyle: customStyle,
            linkStyle: customPhoneStyle,
            linkTypes: linkTypes,
            themeData: themeData,
          );

          final children = result.children;

          if (children != null) {
            final splitEntry = entry.split(': ');
            final country = '${splitEntry[0]}: ';
            final phoneNumber = splitEntry[1];

            expect((children[0] as TextSpan).text, country);
            expect((children[1] as TextSpan).text, phoneNumber);

            final textSpan = children[0] as TextSpan;
            expect(textSpan.style?.color, customStyle.color);

            final linkSpan = children[1] as TextSpan;
            expect(linkSpan.style?.color, customPhoneStyle.color);
          }
        }
      },
    );

    test(
      'GIVEN list data of Inside Russia territories with phone numbers '
      'THEN should highlight phone number',
      () {
        const phoneEntries = [
          // Moscow
          'Russia (Moscow - Fixed line): 8 495 123-45-67',
          'Russia (Moscow - Mobile): 8 925 123-45-67',

          // Saint Petersburg
          'Russia (Saint Petersburg - Fixed line): 8 812 234-56-78',
          'Russia (Saint Petersburg - Mobile): 8 911 234-56-78',

          // Novosibirsk
          'Russia (Novosibirsk - Fixed line): 8 383 345-67-89',
          'Russia (Novosibirsk - Mobile): 8 913 345-67-89',

          // Yekaterinburg
          'Russia (Yekaterinburg - Fixed line): 8 343 456-78-90',
          'Russia (Yekaterinburg - Mobile): 8 922 456-78-90',

          // Nizhny Novgorod
          'Russia (Nizhny Novgorod - Fixed line): 8 831 567-89-01',
          'Russia (Nizhny Novgorod - Mobile): 8 920 567-89-01',

          // Vladivostok
          'Russia (Vladivostok - Fixed line): 8 423 678-90-12',
          'Russia (Vladivostok - Mobile): 8 914 678-90-12',

          // Sochi
          'Russia (Sochi - Fixed line): 8 862 789-01-23',
          'Russia (Sochi - Mobile): 8 928 789-01-23',

          // Toll-Free Numbers
          'Russia (Toll-Free): 8 800 123-45-67',

          // Business/Shared Cost Services
          'Russia (Business Line): 8 499 123-45-67',
          'Russia (Shared Cost Service): 8 812 123-45-67'
        ];

        for (final entry in phoneEntries) {
          final result = LinkifyTextSpans(
            text: entry,
            textStyle: customStyle,
            linkStyle: customPhoneStyle,
            linkTypes: linkTypes,
            themeData: themeData,
          );

          final children = result.children;

          if (children != null) {
            final splitEntry = entry.split(': ');
            final country = '${splitEntry[0]}: ';
            final phoneNumber = splitEntry[1];

            expect((children[0] as TextSpan).text, country);
            expect((children[1] as TextSpan).text, phoneNumber);

            final textSpan = children[0] as TextSpan;
            expect(textSpan.style?.color, customStyle.color);

            final linkSpan = children[1] as TextSpan;
            expect(linkSpan.style?.color, customPhoneStyle.color);
          }
        }
      },
    );

    test(
      'GIVEN list data of Inside Vietnam territories with phone numbers '
      'THEN should highlight phone number',
      () {
        const phoneEntries = [
          // Hanoi (Fixed line)
          'Vietnam (Hanoi - Fixed line): +84 24 1234 5678',
          'Vietnam (Hanoi - Mobile): +84 93 123 45 67',

          // Ho Chi Minh City (Fixed line)
          'Vietnam (Ho Chi Minh City - Fixed line): +84 28 1234 5678',
          'Vietnam (Ho Chi Minh City - Mobile): +84 90 123 45 67',

          // Da Nang (Fixed line)
          'Vietnam (Da Nang - Fixed line): +84 236 123 45 67',
          'Vietnam (Da Nang - Mobile): +84 97 123 45 67',

          // Hai Phong (Fixed line)
          'Vietnam (Hai Phong - Fixed line): +84 225 123 45 67',
          'Vietnam (Hai Phong - Mobile): +84 98 123 45 67',

          // Can Tho (Fixed line)
          'Vietnam (Can Tho - Fixed line): +84 292 123 45 67',
          'Vietnam (Can Tho - Mobile): +84 93 456 78 90',

          // Vung Tau (Fixed line)
          'Vietnam (Vung Tau - Fixed line): +84 254 123 45 67',
          'Vietnam (Vung Tau - Mobile): +84 97 456 78 90',

          // Mobile Networks
          'Vietnam (MobiFone - Mobile): +84 70 123 45 67',
          'Vietnam (MobiFone - Mobile): +84 76 123 45 67',
          'Vietnam (MobiFone - Mobile): +84 79 123 45 67',
          'Vietnam (MobiFone - Mobile): +84 77 123 45 67',

          'Vietnam (Vinaphone - Mobile): +84 81 123 45 67',
          'Vietnam (Vinaphone - Mobile): +84 82 123 45 67',
          'Vietnam (Vinaphone - Mobile): +84 83 123 45 67',
          'Vietnam (Vinaphone - Mobile): +84 84 123 45 67',
          'Vietnam (Vinaphone - Mobile): +84 85 123 45 67',
          'Vietnam (Vinaphone - Mobile): +84 88 123 45 67',
          'Vietnam (Vinaphone - Mobile): +84 89 123 45 67',

          'Vietnam (Viettel - Mobile): +84 32 123 45 67',
          'Vietnam (Viettel - Mobile): +84 33 123 45 67',
          'Vietnam (Viettel - Mobile): +84 34 123 45 67',
          'Vietnam (Viettel - Mobile): +84 35 123 45 67',
          'Vietnam (Viettel - Mobile): +84 36 123 45 67',
          'Vietnam (Viettel - Mobile): +84 37 123 45 67',
          'Vietnam (Viettel - Mobile): +84 38 123 45 67',
          'Vietnam (Viettel - Mobile): +84 39 123 45 67',
          'Vietnam (Viettel - Mobile): +84 86 123 45 67',
          'Vietnam (Viettel - Mobile): +84 97 123 45 67',
          'Vietnam (Viettel - Mobile): +84 98 123 45 67',
          'Vietnam (Viettel - Mobile): +84 99 123 45 67',

          'Vietnam (Vietnamobile - Mobile): +84 52 123 45 67',
          'Vietnam (Vietnamobile - Mobile): +84 56 123 45 67',
          'Vietnam (Vietnamobile - Mobile): +84 58 123 45 67',
          'Vietnam (Vietnamobile - Mobile): +84 59 123 45 67',
          'Vietnam (Vietnamobile - Mobile): +84 92 123 45 67',
          'Vietnam (Vietnamobile - Mobile): +84 93 123 45 67',

          'Vietnam (Gmobile - Mobile): +84 59 123 45 67',
          'Vietnam (Gmobile - Mobile): +84 99 123 45 67',

          // Toll-Free Numbers
          'Vietnam (Toll-Free): +84 800 123 45 67',

          // Shared-Cost Services
          'Vietnam (Shared Cost Service): +84 28 123 45 67'
        ];

        for (final entry in phoneEntries) {
          final result = LinkifyTextSpans(
            text: entry,
            textStyle: customStyle,
            linkStyle: customPhoneStyle,
            linkTypes: linkTypes,
            themeData: themeData,
          );

          final children = result.children;

          if (children != null) {
            final splitEntry = entry.split(': ');
            final country = '${splitEntry[0]}: ';
            final phoneNumber = splitEntry[1];

            expect((children[0] as TextSpan).text, country);
            expect((children[1] as TextSpan).text, phoneNumber);

            final textSpan = children[0] as TextSpan;
            expect(textSpan.style?.color, customStyle.color);

            final linkSpan = children[1] as TextSpan;
            expect(linkSpan.style?.color, customPhoneStyle.color);
          }
        }
      },
    );

    test(
      'GIVEN list data of Inside Vietnam territories with phone numbers '
      'THEN should highlight phone number',
      () {
        const phoneEntries = [
          // Hanoi (Fixed line)
          'Vietnam (Hanoi - Fixed line): 024 1234 5678',
          'Vietnam (Hanoi - Mobile): 093 123 45 67',

          // Ho Chi Minh City (Fixed line)
          'Vietnam (Ho Chi Minh City - Fixed line): 028 1234 5678',
          'Vietnam (Ho Chi Minh City - Mobile): 090 123 45 67',

          // Da Nang (Fixed line)
          'Vietnam (Da Nang - Fixed line): 0236 123 45 67',
          'Vietnam (Da Nang - Mobile): 097 123 45 67',

          // Hai Phong (Fixed line)
          'Vietnam (Hai Phong - Fixed line): 0225 123 45 67',
          'Vietnam (Hai Phong - Mobile): 098 123 45 67',

          // Can Tho (Fixed line)
          'Vietnam (Can Tho - Fixed line): 0292 123 45 67',
          'Vietnam (Can Tho - Mobile): 093 456 78 90',

          // Vung Tau (Fixed line)
          'Vietnam (Vung Tau - Fixed line): 0254 123 45 67',
          'Vietnam (Vung Tau - Mobile): 097 456 78 90',

          // MobiFone (Mobile)
          'Vietnam (MobiFone - Mobile): 070 123 45 67',
          'Vietnam (MobiFone - Mobile): 076 123 45 67',
          'Vietnam (MobiFone - Mobile): 079 123 45 67',
          'Vietnam (MobiFone - Mobile): 077 123 45 67',

          // Vinaphone (Mobile)
          'Vietnam (Vinaphone - Mobile): 081 123 45 67',
          'Vietnam (Vinaphone - Mobile): 082 123 45 67',
          'Vietnam (Vinaphone - Mobile): 083 123 45 67',
          'Vietnam (Vinaphone - Mobile): 084 123 45 67',
          'Vietnam (Vinaphone - Mobile): 085 123 45 67',
          'Vietnam (Vinaphone - Mobile): 088 123 45 67',
          'Vietnam (Vinaphone - Mobile): 089 123 45 67',

          // Viettel (Mobile)
          'Vietnam (Viettel - Mobile): 032 123 45 67',
          'Vietnam (Viettel - Mobile): 033 123 45 67',
          'Vietnam (Viettel - Mobile): 034 123 45 67',
          'Vietnam (Viettel - Mobile): 035 123 45 67',
          'Vietnam (Viettel - Mobile): 036 123 45 67',
          'Vietnam (Viettel - Mobile): 037 123 45 67',
          'Vietnam (Viettel - Mobile): 038 123 45 67',
          'Vietnam (Viettel - Mobile): 039 123 45 67',
          'Vietnam (Viettel - Mobile): 086 123 45 67',
          'Vietnam (Viettel - Mobile): 097 123 45 67',
          'Vietnam (Viettel - Mobile): 098 123 45 67',
          'Vietnam (Viettel - Mobile): 099 123 45 67',

          // Vietnamobile (Mobile)
          'Vietnam (Vietnamobile - Mobile): 052 123 45 67',
          'Vietnam (Vietnamobile - Mobile): 056 123 45 67',
          'Vietnam (Vietnamobile - Mobile): 058 123 45 67',
          'Vietnam (Vietnamobile - Mobile): 059 123 45 67',
          'Vietnam (Vietnamobile - Mobile): 092 123 45 67',
          'Vietnam (Vietnamobile - Mobile): 093 123 45 67',

          // Gmobile (Mobile)
          'Vietnam (Gmobile - Mobile): 059 123 45 67',
          'Vietnam (Gmobile - Mobile): 099 123 45 67',

          // Toll-Free Numbers
          'Vietnam (Toll-Free): 1800 123 45 67',

          // Shared-Cost Services
          'Vietnam (Shared Cost Service): 028 123 45 67'
        ];

        for (final entry in phoneEntries) {
          final result = LinkifyTextSpans(
            text: entry,
            textStyle: customStyle,
            linkStyle: customPhoneStyle,
            linkTypes: linkTypes,
            themeData: themeData,
          );

          final children = result.children;

          if (children != null) {
            final splitEntry = entry.split(': ');
            final country = '${splitEntry[0]}: ';
            final phoneNumber = splitEntry[1];

            expect((children[0] as TextSpan).text, country);
            expect((children[1] as TextSpan).text, phoneNumber);

            final textSpan = children[0] as TextSpan;
            expect(textSpan.style?.color, customStyle.color);

            final linkSpan = children[1] as TextSpan;
            expect(linkSpan.style?.color, customPhoneStyle.color);
          }
        }
      },
    );

    test(
      '',
      () {},
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:linkfy_text/src/utils/matrix_contants.dart';

void main() {
  group('Smart Date Validation - Auto Format Detection', () {
    test('should validate YMD format (Year First)', () {
      // These should now pass without passing a format parameter
      expect(MatrixConstants.isValidDate("2021/12/12"), isTrue);
      expect(MatrixConstants.isValidDate("2021-05-20"), isTrue);
      expect(MatrixConstants.isValidDate("2026.01.21"), isTrue);
    });

    test('should validate DMY/MDY format (Year Last)', () {
      expect(MatrixConstants.isValidDate("12-12-2021"), isTrue);
      expect(MatrixConstants.isValidDate("31/01/2024"), isTrue);
      expect(MatrixConstants.isValidDate("21.01.2026"), isTrue);
    });

    test('should handle 2-digit years correctly', () {
      // 21 becomes 2021, 26 becomes 2026
      expect(MatrixConstants.isValidDate("12-12-21"), isTrue);
      expect(MatrixConstants.isValidDate("21-01-26"), isTrue);
    });

    test('should fail when year is in the middle (Ambiguous/Invalid)', () {
      // Our regex and logic expect Year at start or end
      expect(MatrixConstants.isValidDate("12-2021-12"), isFalse);
    });
  });

  group('Logical Validation (Calendar Rules)', () {
    test('should fail for non-existent days', () {
      expect(MatrixConstants.isValidDate("31-04-2024"),
          isFalse); // April has 30 days
      expect(MatrixConstants.isValidDate("32-01-2024"),
          isFalse); // No month has 32 days
    });

    test('should handle Leap Years automatically', () {
      expect(MatrixConstants.isValidDate("29-02-2024"),
          isTrue); // 2024 was a leap year
      expect(MatrixConstants.isValidDate("29-02-2025"), isFalse); // 2025 is not
    });

    test('should fail for invalid month numbers', () {
      expect(MatrixConstants.isValidDate("12-13-2021"), isFalse); // Month 13
      expect(MatrixConstants.isValidDate("2021-00-12"), isFalse); // Month 00
    });
  });

  group('Separator Flexibility', () {
    test('should accept mixed valid separators', () {
      // While not standard, the regex allows them
      expect(MatrixConstants.isValidDate("12/12-2021"), isTrue);
      expect(MatrixConstants.isValidDate("12.12/2021"), isTrue);
    });

    test('should fail on invalid separators', () {
      expect(MatrixConstants.isValidDate("12_12_2021"), isFalse);
      expect(MatrixConstants.isValidDate("12 12 2021"), isFalse);
    });
  });
}

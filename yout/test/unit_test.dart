// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'package:flutter_test/flutter_test.dart';
import 'package:yout/src/translate/translate_controller.dart';

class NormalizeTestCase {
  final String input;
  final String expected;

  NormalizeTestCase({required this.input, required this.expected});
}

void main() {
  group('Sentence normalization', () {
    test('should simplify sentences', () {
      var cases = [
        NormalizeTestCase(
          input: 'This is my computer.',
          expected: 'this is my computer',
        ),
        NormalizeTestCase(
          input: '..זה המחשב   שלי..',
          expected: 'זה המחשב שלי',
        ),
        NormalizeTestCase(
          input: "WHAT'S wrong with your dog...",
          expected: "what's wrong with your dog",
        ),
        NormalizeTestCase(
          input: "Sometimes 3 numbers are all you need!!!",
          expected: "sometimes 3 numbers are all you need",
        ),
      ];
      TranslateController controller = TranslateController();
      for (var testCase in cases) {
        var actual = controller.normalizeSentence(testCase.input);
        expect(actual, testCase.expected);
      }
    });
  });
}

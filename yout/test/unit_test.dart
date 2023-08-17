// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'package:flutter_test/flutter_test.dart';
import 'package:yout/src/settings/languages.dart';
import 'package:yout/src/translate/translate_controller.dart';

class NormalizeTestCase {
  final String input;
  final String expected;

  NormalizeTestCase({required this.input, required this.expected});
}

class EqualsTestCase {
  final String v1;
  final String v2;
  final Language lang;

  EqualsTestCase({required this.v1, required this.v2, required this.lang});
}

void main() {
  group('Sentence normalization', () {
    TranslateController controller = TranslateController();

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
      for (var testCase in cases) {
        var actual = controller.normalizeSentence(Language.eng, testCase.input);
        expect(actual, testCase.expected);
      }
    });

    test('Sentences should be equal', () {
      var cases = [
        EqualsTestCase(
            v1: 'すみません 何時ですか', v2: 'すみません、何時ですか。', lang: Language.jpn),
      ];
      for (var testCase in cases) {
        var actual = controller
            .isSameSentence(testCase.lang, testCase.v1, [testCase.v2]);
        expect(actual, true,
            reason: 'v1: "${testCase.v1}", v2: "${testCase.v2}"');
      }
    });
  });
}

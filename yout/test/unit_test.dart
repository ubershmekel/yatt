// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'package:flutter/material.dart';
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
        EqualsTestCase(v1: 'リンゴは好きですか。', v2: 'りんごは好きですか？', lang: Language.jpn),
        EqualsTestCase(v1: 'あなたは大丈夫ですか', v2: '君は大丈夫ですか', lang: Language.jpn),
        EqualsTestCase(v1: '僕は学生です', v2: '私は学生です', lang: Language.jpn),
        EqualsTestCase(v1: '僕は学生です', v2: '俺は学生です', lang: Language.jpn),
        EqualsTestCase(v1: 'Είμαι 19.', v2: 'είμαι 19', lang: Language.ell),
        EqualsTestCase(
            v1: 'ב-2023 גרנו בלונדון',
            v2: 'ב2023 גרנו בלונדון',
            lang: Language.heb),
        EqualsTestCase(
            v1: 'ב-2023 גרנו בלונדון',
            v2: 'ב 2023 גרנו בלונדון',
            lang: Language.heb),
        EqualsTestCase(
            // test the same idea as the previous but mid-sentence
            v1: 'גם ב-2023 נהיה בלונדון',
            v2: 'גם ב2023 נהיה בלונדון',
            lang: Language.heb),
        EqualsTestCase(
            v1: 'If it rains tomorrow, I will stay home.',
            v2: "If it rains tomorrow, I'll stay home.",
            lang: Language.eng),
      ];
      for (var testCase in cases) {
        var actualIsSame = controller
            .isSameSentence(testCase.lang, testCase.v1, [testCase.v2]);
        if (!actualIsSame) {
          debugPrint(controller.normalizeSentence(testCase.lang, testCase.v1));
          debugPrint(controller.normalizeSentence(testCase.lang, testCase.v2));
        }
        expect(actualIsSame, true,
            reason: 'v1: "${testCase.v1}", v2: "${testCase.v2}"');
      }
    });

    test('Sentences should NOT be equal', () {
      var cases = [
        EqualsTestCase(
            v1: 'ב2023 גרנו בלונדון',
            v2: 'ב2023גרנובלונדון',
            lang: Language.heb),
      ];
      for (var testCase in cases) {
        var actualIsSame = controller
            .isSameSentence(testCase.lang, testCase.v1, [testCase.v2]);
        if (actualIsSame) {
          debugPrint(controller.normalizeSentence(testCase.lang, testCase.v1));
          debugPrint(controller.normalizeSentence(testCase.lang, testCase.v2));
        }
        expect(actualIsSame, false,
            reason: 'v1: "${testCase.v1}", v2: "${testCase.v2}"');
      }
    });
  });
}

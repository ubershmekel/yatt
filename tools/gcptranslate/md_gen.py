from typing import List
import os

import api_task

script_dir = os.path.dirname(__file__)

examples = [
    "In 2013 we lived in London.",
    "In 2013 we were living in London.",
    "During 2013, London was our home.",
    "Back in 2013, we resided in London.",
    "In the year 2013, we lived in London.",
    "Our place of residence was London in 2013.",
    "We were based in London in 2013.",

]

output_langs = (
    "eng",
    "ara",
    "deu",
    "ell",
    "fra",
    "heb",
    "ita",
    "jpn",
    "kor",
    "por",
    "rus",
    "spa",
)


lang_code_3to2 = {
    "eng": "en",
    "ara": "ar",
    "deu": "de",
    "ell": "el",
    "fra": "fr",
    "heb": "he",
    "ita": "it",
    "jpn": "ja",
    "kor": "ko",
    "por": "pt",
    "rus": "ru",
    "spa": "es",
}


def generate_md(lang_to_examples):
    md_lines = []
    for lang in output_langs:
        if lang not in lang_to_examples:
            # we only want to use complete entries
            # print(f"missing lang {lang}")
            # return
            continue
        md_lines.append(f"# lang:{lang}")
        for sentence in dedupe_sentences(lang_to_examples[lang]):
            md_lines.append(sentence)

    md_text = '\n\n'.join(md_lines)
    return md_text


def to_md_name(name: str) -> str:
    return "".join(x for x in name.lower() if x.isalnum()) + ".md"


def dedupe_sentences(sentences: List[str]):
    deduped = []
    seen = set()
    for sent in sentences:
        if to_md_name(sent) in seen:
            continue
        seen.add(to_md_name(sent))
        deduped.append(sent)
    return deduped


def main():
    out_dir = script_dir + '/out'
    if not os.path.isdir(out_dir):
        os.mkdir(out_dir)

    lang_to_examples = {
        "eng": examples,
    }
    for c3, c2 in lang_code_3to2.items():
        if c3 == "eng":
            continue
        lang_to_examples[c3] = api_task.translate(examples, c2)
        print(lang_to_examples[c3])
    md_text = generate_md(lang_to_examples)
    md_filename = to_md_name(examples[0])

    with open(f'{out_dir}/{md_filename}', 'w', encoding='utf8') as fout:
        fout.write(md_text)


if __name__ == "__main__":
    main()

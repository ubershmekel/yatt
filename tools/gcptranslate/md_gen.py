from typing import List

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
        deduped.append(sent)
    return deduped
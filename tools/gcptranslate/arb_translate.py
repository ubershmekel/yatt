from collections import OrderedDict
import os
import json

import api_task
import md_gen

script_dir = os.path.dirname(__file__)

arb_en = os.path.join(script_dir, r'../../yout/lib/src/localization/app_en.arb')
arb_dir = os.path.dirname(arb_en)

def main():
    en_data = json.load(open(arb_en, encoding='utf8'))
    en_id_key_line = []
    for key, line in en_data.items():
        if key.startswith('@'):
            continue
        if type(line) != str:
            print(f"Skipping {key} because it's not a string")
            continue
        en_id_key_line.append((len(en_id_key_line), key, line))

    en_lines = [i[2] for i in en_id_key_line]
    print(f"enlines: {en_lines}")
    for c3, c2 in md_gen.lang_code_3to2.items():
        print(f"Translating {c3}...")
        if c3 == "eng":
            continue
        fname = f'{arb_dir}/app_{c2}.arb'
        lines_to_translate = en_lines
        translated_id_key_line = en_id_key_line
        lang_arb_data = en_data.copy()
        if os.path.isfile(fname):
            # see what's missing in the existing arb file
            lines_to_translate = []
            lang_arb_data = json.load(open(fname, encoding='utf8'))
            translated_id_key_line = []
            for id, key, line in en_id_key_line:
                if key not in lang_arb_data or lang_arb_data[key].strip() == "":
                    # we must translate this missing value
                    lines_to_translate.append(line)
                    translated_id_key_line.append((id, key, line))
        
        print(f"Translating {len(lines_to_translate)} lines")
        if lines_to_translate:
            translated_lines = api_task.translate(lines_to_translate, c2)
            print(f"{translated_lines}")
            print(f"{translated_id_key_line}")
            for i, translated_line in enumerate(translated_lines):
                _id, key, _en_line = translated_id_key_line[i]
                lang_arb_data[key] = translated_line
        out_data = OrderedDict(sorted(lang_arb_data.items()))
        open(fname, 'w', encoding='utf8').write(json.dumps(out_data, indent=2, ensure_ascii=False))

main()
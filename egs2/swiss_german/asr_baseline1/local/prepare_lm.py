import os
import sys

from prepare_text import normalize_text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP


def main(source_text: str, target_dir: str):
    os.mkdir(target_dir)
    counter = 0
    with open(source_text, 'r', encoding='utf-8') as input:
        with open(f'{target_dir}/text', mode='w', encoding='utf-8') as output:
            for sentence in input:
                text = normalize_text(sentence, SG_CHAR_VOCAB, SG_CHAR_LOOKUP)
                text = str(counter) + " " + text
                counter += 1
                if len(text.rstrip().split(maxsplit=1)) == 2:
                    output.write(f"{text}\n")


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])

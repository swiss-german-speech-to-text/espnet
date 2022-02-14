import sys

from prepare_text import normalize_text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP


def main(source_text: str, target_dir: str):
    with open(source_text, 'r', encoding='utf-8') as input:
        with open(f'{target_dir}/text', encoding='utf-8') as output:
            text = normalize_text(input.readline(), SG_CHAR_VOCAB, SG_CHAR_LOOKUP)
            output.write(f"{text}\n")


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])

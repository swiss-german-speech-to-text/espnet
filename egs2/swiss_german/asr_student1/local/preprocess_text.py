import os.path
import sys

from prepare_text import normalize_text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP


def main(source_file: str):
    assert os.path.exists(source_file), f"{source_file} does not exist"
    assert os.path.isfile(source_file), f"{source_file} is not a file"

    with open(source_file, mode='r', encoding='utf-8') as f:
        texts = f.readlines()

    def aux(text: str):
        split = text.split(' ')
        utterance_id = split[0]
        text = ' '.join(split[1:])
        text = normalize_text(text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP) + "\n"
        return utterance_id + ' ' + text

    texts = [aux(text) for text in texts]

    with open(source_file, mode='w', encoding='utf-8') as f:
        f.writelines(texts)


if __name__ == '__main__':
    main(sys.argv[1])
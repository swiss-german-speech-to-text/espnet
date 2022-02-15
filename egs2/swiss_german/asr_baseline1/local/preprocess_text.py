import os.path
import sys

from prepare_text import normalize_text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP


def main(source_file: str):
    assert os.path.exists(source_file), f"{source_file} does not exist"
    assert os.path.isfile(source_file), f"{source_file} is not a file"

    with open(source_file, mode='r', encoding='utf-8') as f:
        texts = f.readlines()

    texts = [normalize_text(text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP) for text in texts]

    with open(source_file, mode='w', encoding='utf-8') as f:
        f.writelines(texts)


if __name__ == '__main__':
    main(sys.argv[1])

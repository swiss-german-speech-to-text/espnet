import os
import sys

from prepare_text import normalize_text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP
from nltk.tokenize import sent_tokenize


def main(source_text: str, target_dir: str):
    if os.path.exists(target_dir):
        print("Assuming LM already preprocessed, exiting without any changes.")
        return
    os.mkdir(target_dir)
    counter = 0
    with open(source_text, 'r', encoding='utf-8') as input:
        with open(f'{target_dir}/text', mode='w', encoding='utf-8') as output:
            for line in input:
                for sentence in sent_tokenize(line, language='german'):
                    text = normalize_text(sentence, SG_CHAR_VOCAB, SG_CHAR_LOOKUP)
                    text = str(counter) + " " + text
                    if len(text.rstrip().split(maxsplit=1)) == 2 and len(text) <= 2000:
                        output.write(f"{text}\n")
                        counter += 1


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])

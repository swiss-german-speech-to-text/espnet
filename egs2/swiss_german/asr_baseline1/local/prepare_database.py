import sys

import pandas as pd
from prepare_text import normalize_text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP


def main(source_csv: str, target: str):
    df = pd.read_csv(source_csv, sep='\t', encoding='utf-8')
    df = df.apply(lambda text: normalize_text(text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP), index=['sentence'], axis=1)
    df.to_csv(target, sep="\t", encoding='utf-8')


if __name__ == '__main__':
    main(sys.argv[0], sys.argv[1])

import os.path
import sys

import pandas as pd
from prepare_text import normalize_text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP


def main(source_csv: str, target: str):
    assert os.path.exists(source_csv), f"{source_csv} does not exist"
    assert os.path.isfile(source_csv), f"{source_csv} is not a file"
    df = pd.read_csv(source_csv, sep='\t', encoding='utf-8')
    assert (df.keys() == ['client_id', 'path', 'sentence', 'up_votes', 'down_votes', 'age',
       'gender', 'accent', 'iou_estimate']).all(), "Not all columns present"
    df.sentence = df.sentence.apply(lambda text: normalize_text(text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP))
    df.to_csv(target, sep="\t", encoding='utf-8')


if __name__ == '__main__':
    main(sys.argv[0], sys.argv[1])

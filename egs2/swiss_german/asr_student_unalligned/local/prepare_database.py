import os.path
import sys

import pandas as pd
from prepare_text import normalize_text, SG_CHAR_VOCAB, SG_CHAR_LOOKUP


def main(source_csv: str):
    columns = ['client_id', 'path', 'sentence', 'up_votes', 'down_votes', 'age',
               'gender', 'accent', 'iou_estimate']
    path = [os.path.dirname(source_csv) + '/clips/' + file for file in list(filter(lambda x: x.endswith('.flac'), os.listdir(os.path.dirname(source_csv) + '/clips')))]
    client_id = list(range(0,len(path)))
    sentence = ["Dummy"] * len(path)
    up_votes = [""] * len(path)
    down_votes = [""] * len(path)
    age = [""] * len(path)
    gender = [""] * len(path)
    accent = [""] * len(path)
    iou_estimate = [0.9] * len(path)

    df = pd.DataFrame(list(zip(client_id, path, sentence, up_votes, down_votes, age, gender, accent, iou_estimate)),
                      columns=columns)
    df.to_csv(source_csv, sep="\t", encoding='utf-8', index=False)


if __name__ == '__main__':
    main(sys.argv[1])

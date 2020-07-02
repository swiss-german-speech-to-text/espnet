import argparse
import json
import random
import os

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('input', type=str)
    args = parser.parse_args()

    with open(args.input, mode='r', encoding='utf-8') as f:
        data = json.load(f)

    print(f'splitting {args.input} with total {len(data["utts"])} elements')

    utts_common_voice = {k: v for k, v in data['utts'].items() if '-common_voice_de_' in k}
    utts_other = list({k: v for k, v in data['utts'].items() if '-common_voice_de_' not in k}.items())
    random.shuffle(utts_other)

    print(f'creating split common_voice with {len(utts_common_voice)} elements')
    with open(f'{os.path.splitext(args.input)[0]}_cv.json', mode='w', encoding='utf8') as f:
        json.dump({'utts': utts_common_voice}, f)

    for split in [20, 40, 60, 80, 100]:
        utts_split = dict(utts_other[:len(utts_other) * split // 100])
        utts = {**utts_common_voice,**utts_split}
        print(f'creating split {split} with {len(utts)} elements')
        file = f'{os.path.splitext(args.input)[0]}_ch_{split}.json'
        with open(file, mode='w', encoding='utf-8') as f:
            json.dump({'utts': utts}, f)

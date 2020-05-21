import argparse
import os

import re


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('input', type=str)
    parser.add_argument('output', type=str)
    args = parser.parse_args()
    assert args.input != args.output
    print(f'reindexing {args.input} to {args.output}')

    with open(args.input, mode='r', encoding='utf-8') as in_f:
        with open(args.output, mode='w', encoding='utf-8') as out_f:
            out_f.write('client_id\tpath\tsentence\tup_votes\tdown_votes\tage\tgender\taccent\n')
            next(in_f)
            i = 0
            for x in in_f:
                x = x.strip()
                fields = x.split('\t')
                fields[0] = str(i)
                out_f.write('\t'.join(fields) + '\n')
                i += 1

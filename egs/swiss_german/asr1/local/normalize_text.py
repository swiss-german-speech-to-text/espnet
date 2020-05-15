import argparse
import os

import re
ALLOWED_CHARS = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    'ä', 'ö', 'ü',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    ' '
}

WHITESPACE_REGEX = re.compile(r'[ \t]+')

def norm(transcript):
    transcript = transcript.lower()
    transcript = transcript.replace('á', 'a')
    transcript = transcript.replace('à', 'a')
    transcript = transcript.replace('â', 'a')
    transcript = transcript.replace('ç', 'c')
    transcript = transcript.replace('é', 'e')
    transcript = transcript.replace('è', 'e')
    transcript = transcript.replace('ê', 'e')
    transcript = transcript.replace('í', 'i')
    transcript = transcript.replace('ì', 'i')
    transcript = transcript.replace('î', 'i')
    transcript = transcript.replace('ñ', 'n')
    transcript = transcript.replace('ó', 'o')
    transcript = transcript.replace('ò', 'o')
    transcript = transcript.replace('ô', 'o')
    transcript = transcript.replace('ú', 'u')
    transcript = transcript.replace('ù', 'u')
    transcript = transcript.replace('û', 'u')
    transcript = transcript.replace('ș', 's')
    transcript = transcript.replace('ş', 's')
    transcript = transcript.replace('ß', 'ss')
    transcript = transcript.replace('-', ' ') # Not used consistently, better to replace with space as well
    transcript = transcript.replace('–', ' ')
    transcript = transcript.replace('/', ' ')
    transcript = WHITESPACE_REGEX.sub(' ', transcript)
    transcript = ''.join([char for char in transcript if char in ALLOWED_CHARS])
    transcript = WHITESPACE_REGEX.sub(' ', transcript)
    transcript = transcript.strip()
    return transcript


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('input', type=str)
    parser.add_argument('output', type=str)
    args = parser.parse_args()
    assert args.input != args.output
    print(f'normalizing {args.input} to {args.output}')

    with open(args.input, mode='r', encoding='utf-8') as in_f:
        with open(args.output, mode='w', encoding='utf-8') as out_f:
            if args.input.endswith('.tsv'):
                out_f.write('client_id\tpath\tsentence\tup_votes\tdown_votes\tage\tgender\taccent\n')
                next(in_f)
                for x in in_f:
                    x = x.strip()
                    fields = x.split('\t')
                    fields[2] = norm(fields[2])
                    out_f.write('\t'.join(fields) + '\n')
            else:
                for x in in_f:
                    out_f.write(norm(x.strip()) + '\n')

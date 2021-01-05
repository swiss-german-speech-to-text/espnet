import argparse
import glob
import json
import os

from nltk.translate.bleu_score import corpus_bleu


def main(args):
    dir_path = os.path.realpath(args.results_root)
    search_path = os.path.join(dir_path, '**/data.json')

    bleu_scores = {}
    for fname in glob.iglob(search_path, recursive=True):
        file_path = os.path.realpath(fname)
        with open(file_path, 'r') as f:
            run_results = json.load(f)
        references, hypotheses = [], []
        for utt_id, utt_results in run_results['utts'].items():
            # print("HYP", utt_results['output'][0]['rec_text'].replace('<eos>', '').strip('▁').split('▁'))
            # print("REF", utt_results['output'][0]['text'].split())
            hypotheses.append(utt_results['output'][0]['rec_text'].replace('<eos>', '').strip('▁').split('▁'))
            references.append([utt_results['output'][0]['text'].split()])
        bleu_scores[file_path] = corpus_bleu(references, hypotheses)
        print(f'{file_path}: {bleu_scores[file_path]}')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--results-root', type=str)
    main(parser.parse_args())
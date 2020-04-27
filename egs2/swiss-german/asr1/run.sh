#!/bin/bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

# 0   Download data to downloads
# 1   Preparing data: downloads -> data
# 3   Format wav.scp: data/ -> ${data_feats}/org/
# 4   Remove short data: ${data_feats}/org -> ${data_feats}
# 5   Generate token_list from ${data_feats}/srctexts using BPE
# 6   LM collect stats: train_set=${data_feats}/srctexts, dev_set=${lm_dev_text}
# 7   LM Training: train_set=${data_feats}/srctexts, dev_set=${lm_dev_text}
# 8   Calc perplexity: ${lm_test_text}
# 9   ASR collect stats: train_set=${_asr_train_dir}, dev_set=${_asr_dev_dir}
# 10  ASR Training: train_set=${_asr_train_dir}, dev_set=${_asr_dev_dir}
# 11  Decoding: training_dir=${asr_exp}
# 12  Scoring
# 13  Pack model: ${asr_exp}/packed.tgz
stage=6
stop_stage=12

ngpu=1

train_set=de_ch_train # de_train, ch_train, de_ch_train
train_dev=ch_dev
train_test=ch_dev

asr_config=conf/train_asr.yaml
lm_config=conf/train_lm.yaml
decode_config=conf/decode_asr.yaml

./asr.sh \
    --stage ${stage} \
    --stop_stage ${stop_stage} \
    --local_data_opts "" \
    --use_lm true \
    --lm_config "${lm_config}" \
    --token_type bpe \
    --nbpe 150 \
    --ngpu ${ngpu} \
    --feats_type raw \
    --asr_config "${asr_config}" \
    --decode_config "${decode_config}" \
    --train_set "${train_set}" \
    --dev_set "${train_dev}" \
    --eval_sets "${train_test}" \
    --srctexts "data/${train_set}/text" "$@"

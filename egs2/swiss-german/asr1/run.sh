#!/bin/bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

ngpu=1

train_set=de_ch_train
train_dev=ch_dev
train_test=ch_dev

asr_config=conf/train_asr.yaml
lm_config=conf/train_lm.yaml
decode_config=conf/decode_asr.yaml


./asr.sh \
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

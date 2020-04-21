#!/bin/bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

lang=sg

raw_data="/media/nas08-data01/lukas/speech2text/espnet_swiss_german/downloads/SwissText2020"

train_set=valid_train_${lang}
train_dev=valid_dev_${lang}
train_test=valid_test_${lang}

asr_config=conf/train_asr.yaml
lm_config=conf/train_lm.yaml
decode_config=conf/decode_asr.yaml


./asr.sh \
    --local_data_opts "--lang ${lang} --raw_data ${raw_data}" \
    --use_lm false \
    --lm_config "${lm_config}" \
    --token_type bpe \
    --nbpe 150 \
    --feats_type raw \
    --asr_config "${asr_config}" \
    --decode_config "${decode_config}" \
    --train_set "${train_set}" \
    --dev_set "${train_dev}" \
    --eval_sets "${train_test}" \
    --srctexts "data/${train_set}/text" "$@"

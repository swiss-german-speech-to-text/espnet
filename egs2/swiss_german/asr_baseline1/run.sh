#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set="train"
train_dev="dev"
test_set="data/spc/test data/spc/valid data/clickworker/test data/dialektsammlung/test data/snf/test"
lm_train_set="lm/train"
lm_val_set="lm/valid"

asr_config=conf/tuning/train_asr_conformer5.yaml
lm_config=conf/train_lm.yaml
inference_config=conf/decode_asr.yaml

nbpe=5000

./asr.sh \
    --ngpu 4 \
    --use_lm true \
    --lm_config "${lm_config}" \
    --token_type bpe \
    --nbpe $nbpe \
    --feats_type raw \
    --max_wav_duration 12 \
    --speed_perturb_factors "0.9 1.0 1.1" \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --bpe_train_text "data/${lm_train_set}" \
    --lm_train_text "data/${lm_train_set}" \
    --lm_dev_text "data/${lm_val_set}" "$@"
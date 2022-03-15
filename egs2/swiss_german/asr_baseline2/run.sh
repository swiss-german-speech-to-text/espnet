#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set="train"
train_dev="dev"
test_set="spc/test spc/valid clickworker/valid clickworker/test dialektsammlung/valid dialektsammlung/test snf/test stadt_bern_stadtrat_alligned/valid"
lm_train_set="lm/train/text"
lm_val_set="lm/valid/text"

asr_config=conf/tuning/train_asr_conformer5.yaml
lm_config=conf/train_lm.yaml
inference_config=conf/decode_asr.yaml

nbpe=5000

./asr.sh \
    --stage 11 \
    --stop_stage 1000 \
    --asr_exp "exp2" \
    --ngpu 1 \
    --use_lm false \
    --lang de \
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
    --bpe_input_sentence_size 10000000 \
    --lm_train_text "data/${lm_train_set}" \
    --lm_dev_text "data/${lm_val_set}" "$@"

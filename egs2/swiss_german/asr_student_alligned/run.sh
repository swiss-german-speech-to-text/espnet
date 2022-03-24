#!/bin/bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

lang=de # en de fr cy tt kab ca zh-TW it fa eu es ru tr nl eo zh-CN rw pt zh-HK cs pl uk

train_set="train"
train_dev="dev"
test_set="spc/test spc/valid clickworker/valid clickworker/test dialektsammlung/valid dialektsammlung/test snf/test"
lm_train_set="lm/train/text"
lm_val_set="lm/valid/text"

asr_config=conf/tuning/train_asr_transformer.yaml
lm_config=conf/train_lm.yaml
inference_config=conf/tuning/tuning/decode_transformer.yaml

if [[ "zh" == *"${lang}"* ]]; then
  nbpe=2500
elif [[ "fr" == *"${lang}"* ]]; then
  nbpe=350
elif [[ "es" == *"${lang}"* ]]; then
  nbpe=235
else
  nbpe=150
fi

# Train teacher
local/asr.sh \
    --stage 0 \
    --stop_stage 4 \
    --ngpu 4 \
    --lang "${lang}" \
    --dumpdir $TMPDIR/dump \
    --expdir $TMPDIR/exp \
    --use_lm true \
    --lm_config "${lm_config}" \
    --token_type bpe \
    --nbpe $nbpe \
    --feats_type raw \
    --speed_perturb_factors "0.9 1.0 1.1" \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --bpe_train_text "data/${lm_train_set}" \
    --bpe_input_sentence_size 10000000 \
    --lm_dev_text "data/${lm_val_set}" \
    --lm_train_text "data/${lm_val_set}" "$@"


# Decode data
test_set="kanton_ar_kantonsrat/no_labels kanton_ow_kantonsrat/no_labels stadt_bern_stadtrat/no_labels"

local/asr.sh \
    --stage 11 \
    --stop_stage 12 \
    --ngpu 4 \
    --lang "${lang}" \
    --dumpdir $TMPDIR/dump \
    --expdir $TMPDIR/exp \
    --use_lm true \
    --lm_config "${lm_config}" \
    --token_type bpe \
    --nbpe $nbpe \
    --feats_type raw \
    --speed_perturb_factors "0.9 1.0 1.1" \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --bpe_train_text "data/${lm_train_set}" \
    --bpe_input_sentence_size 10000000 \
    --lm_dev_text "data/${lm_val_set}" \
    --lm_train_text "data/${lm_val_set}" "$@"


# Prepare new train data
local/prepare_student_data.sh

# Train with the new data
train_set="teacher_labeled"
test_set="spc/test spc/valid clickworker/valid clickworker/test dialektsammlung/valid dialektsammlung/test snf/test"

# Data preparation
local/asr.sh \
    --stage 2 \
    --stop_stage 5 \
    --ngpu 4 \
    --lang "${lang}" \
    --dumpdir $TMPDIR/dump \
    --expdir $TMPDIR/exp \
    --use_lm true \
    --lm_config "${lm_config}" \
    --token_type bpe \
    --nbpe $nbpe \
    --feats_type raw \
    --speed_perturb_factors "0.9 1.0 1.1" \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --bpe_train_text "data/${lm_train_set}" \
    --bpe_input_sentence_size 10000000 \
    --lm_dev_text "data/${lm_val_set}" \
    --lm_train_text "data/${lm_val_set}" "$@"

local/asr.sh \
    --stage 9 \
    --stop_stage 100 \
    --ngpu 4 \
    --lang "${lang}" \
    --dumpdir $TMPDIR/dump \
    --expdir $TMPDIR/exp \
    --use_lm true \
    --lm_config "${lm_config}" \
    --token_type bpe \
    --nbpe $nbpe \
    --feats_type raw \
    --speed_perturb_factors "0.9 1.0 1.1" \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --bpe_train_text "data/${lm_train_set}" \
    --bpe_input_sentence_size 10000000 \
    --lm_dev_text "data/${lm_val_set}" \
    --lm_train_text "data/${lm_val_set}" "$@"
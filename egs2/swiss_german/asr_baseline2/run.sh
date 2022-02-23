#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set="train"
train_dev="dev"
test_set="spc/test spc/valid clickworker/valid clickworker/test dialektsammlung/valid dialektsammlung/test snf/test"
lm_train_set="lm/train/text"
lm_val_set="lm/valid/text"

asr_config=conf/tuning/train_asr_conformer5.yaml
lm_config=conf/train_lm.yaml
inference_config=conf/decode_asr.yaml

nbpe=5000

ml CMake/3.15.3-GCCcore-8.3.0
ml SoX/14.4.2-GCCcore-8.3.0
ml libsndfile/1.0.28-GCCcore-8.3.0
ml FFmpeg/.4.2.1-GCCcore-8.3.0
ml FLAC/1.3.3-GCCcore-8.3.0
ml cuDNN/8.1.0.77-CUDA-11.2.1
ml Python/3.7.4-GCCcore-8.3.0

source /scicore/home/graber0001/schran0000/espnet/tools/venv/bin/activate
export PATH=/scicore/home/graber0001/schran0000/opt/bin:$PATH
export LD_LIBRARY_PATH=/scicore/home/graber0001/schran0000/opt/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/scicore/home/graber0001/schran0000/opt/lib/pkgconfig:$PKG_CONFIG_PATH
export WANDB_DIR=/scicore/home/graber0001/schran0000/wandb
export TMPDIR=/scicore/home/graber0001/schran0000/wandb

./asr.sh \
    --stage 0 \
    --stop_stage 1000 \
    --ngpu 4 \
    --use_lm true \
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

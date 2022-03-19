#!/usr/bin/env bash

# Copyright 2020 Johns Hopkins University (Shinji Watanabe)
#  Apache 2.0  (http://www.apache.org/licenses/LICENSE-2.0)

. ./path.sh || exit 1;
. ./cmd.sh || exit 1;
. ./db.sh || exit 1;

# general configuration
stage=1       # start from 0 if you need to start from data preparation
stop_stage=1
SECONDS=0

. utils/parse_options.sh || exit 1;

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}

# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

log "data preparation started"

if [ ${stage} -le 0 ] && [ ${stop_stage} -ge 0 ]; then
    log "stage1: Download data to downloads"
    log "Not implemented yet"
    exit 1
fi

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    log "stage2: Preparing data"
    ### Task dependent. You have to make data the following preparation part by yourself.
    DIR="data/kanton_ar_kantonsrat"
    if [ -d "$DIR" ]; then
      log "Preprocessing already done, skipping kanton_ar_kantonsrat"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/kanton_ar_kantonsrat_unaligned "train_all" data/kanton_ar_kantonsrat/teacher_labels
      rm data/kanton_ar_kantonsrat/teacher_labels/text
      cp exp/asr_train_asr_conformer5_raw_de_bpe150_sp/decode_asr_asr_model_valid.acc.ave/kanton_ar_kantonsrat/no_labels/text data/kanton_ar_kantonsrat/teacher_labels/text
    fi

    DIR="data/kanton_ow_kantonsrat"
    if [ -d "$DIR" ]; then
      log "Preprocessing already done, skipping kanton_ow_kantonsrat"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/kanton_ow_kantonsrat_unaligned "train_all" data/kanton_ow_kantonsrat/teacher_labels
      rm data/kanton_ow_kantonsrat/teacher_labels/text
      cp exp/asr_train_asr_conformer5_raw_de_bpe150_sp/decode_asr_asr_model_valid.acc.ave/kanton_ow_kantonsrat/no_labels/text data/kanton_ow_kantonsrat/teacher_labels/text
    fi

    DIR="data/stadt_bern_stadtrat_aligned"
    if [ -d "$DIR" ]; then
      log "Preprocessing already done, skipping kanton_ar_kantonsrat"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/stadt_bern_stadtrat_unaligned "train" data/stadt_bern_stadtrat/teacher_labels
      rm data/stadt_bern_stadtrat/teacher_labels/text
      cp exp/asr_train_asr_conformer5_raw_de_bpe150_sp/decode_asr_asr_model_valid.acc.ave/stadt_bern_stadtrat/no_labels/text data/stadt_bern_stadtrat/teacher_labels/text

    fi
    utils/combine_data.sh --extra_files utt2num_frames data/teacher_labeled data/stadt_bern_stadtrat/teacher_labels data/stadt_bern_stadtrat/teacher_labels data/kanton_ow_kantonsrat/teacher_labels data/kanton_ow_kantonsrat/teacher_labels data/kanton_ar_kantonsrat/teacher_labels data/kanton_ar_kantonsrat/teacher_labels
fi

log "Successfully finished. [elapsed=${SECONDS}s]"
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
    DIR="data/spc"
    if [ -d "$DIR" ]; then
     log "Preprocessing already done, skipping spc"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/spc "train" data/spc/train
      local/data_prep.pl downloads/stt/spc "valid" data/spc/valid
      local/data_prep.pl downloads/stt/spc "test" data/spc/test

      utils/combine_data.sh --extra_files utt2num_frames data/train data/spc/train data/spc/train
      utils/combine_data.sh --extra_files utt2num_frames data/dev data/spc/valid data/spc/valid
    fi


    DIR="data/clickworker"
    if [ -d "$DIR" ]; then
      log "Preprocessing already done, skipping clickworker"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/clickworker_test_set "private" data/clickworker/test
      local/data_prep.pl downloads/stt/clickworker_test_set "public" data/clickworker/valid
    fi

    DIR="data/dialektsammlung"
    if [ -d "$DIR" ]; then
      log "Preprocessing already done, skipping dialektsammlung"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/dialektsammlung "test" data/dialektsammlung/test
      local/data_prep.pl downloads/stt/dialektsammlung "train" data/dialektsammlung/train
      local/data_prep.pl downloads/stt/dialektsammlung "valid" data/dialektsammlung/valid
    fi

    DIR="data/snf"
    if [ -d "$DIR" ]; then
      log "Preprocessing already done, skipping snf"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/snf/testset/v0.2 "export_v0.2" data/snf/test
      # TODO test / valid split
    fi

        DIR="data/kanton_ar_kantonsrat"
    if [ -d "$DIR" ]; then
      log "Preprocessing already done, skipping kanton_ar_kantonsrat"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/kanton_ar_kantonsrat_unaligned "train_all" data/kanton_ar_kantonsrat/no_labels
    fi

    DIR="data/kanton_ow_kantonsrat"
    if [ -d "$DIR" ]; then
      log "Preprocessing already done, skipping kanton_ow_kantonsrat"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/kanton_ow_kantonsrat_unaligned "train_all" data/kanton_ow_kantonsrat/no_labels
    fi

    DIR="data/stadt_bern_stadtrat_aligned"
    if [ -d "$DIR" ]; then
      log "Preprocessing already done, skipping kanton_ar_kantonsrat"
    else
      mkdir $DIR
      local/data_prep.pl downloads/stt/stadt_bern_stadtrat_unaligned "train" data/stadt_bern_stadtrat/no_labels
    fi

    mkdir -p "data/lm"
    python3 local/prepare_lm.py downloads/lm/combined/train.txt data/lm/train
    python3 local/prepare_lm.py downloads/lm/combined/valid.txt data/lm/valid
fi

log "Successfully finished. [elapsed=${SECONDS}s]"
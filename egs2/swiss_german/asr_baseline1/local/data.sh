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
    python3 local/prepare_database.py downloads/stt/spc/train.tsv downloads/stt/spc/train_kaldi.tsv
    python3 local/prepare_database.py downloads/stt/spc/valid.tsv downloads/stt/spc/valid_kaldi.tsv
    python3 local/prepare_database.py downloads/stt/spc/test.tsv downloads/stt/spc/test_kaldi.tsv
    local/data_prep.pl downloads/stt/spc "train_kaldi" data/spc/train
    local/data_prep.pl downloads/stt/spc "valid_kaldi" data/spc/valid
    local/data_prep.pl downloads/stt/spc "test_kaldi" data/spc/test

    python3 local/prepare_database.py downloads/stt/clickworker_test_set/all.tsv downloads/stt/clickworker/all_kaldi.tsv
    local/data_prep.pl downloads/stt/clickworker_test_set "all_kaldi" data/clickworker/test

    python3 local/prepare_database.py downloads/stt/dialektsammlung/test.tsv downloads/stt/dialektsammlung/test_kaldi.tsv
    local/data_prep.pl downloads/stt/dialektsammlung "test_kaldi" data/dialektsammlung/test

    python3 local/prepare_database.py downloads/stt/snf/testset/v0.1/export_v0.1.tsv downloads/stt/snf/testset/v0.1/export_v0.1_kaldi.tsv
    local/data_prep.pl downloads/stt/snf/testset/v0.1 "export_v0.1_kaldi" data/snf/test

    utils/combine_data.sh --extra_files utt2num_frames data/train data/spc/train data/spc/train
    utils/combine_data.sh --extra_files utt2num_frames data/dev data/spc/valid data/spc/valid

    python3 local/prepare_lm.py downloads/lm/train data/lm/train
    python3 local/prepare_lm.py downloads/lm/valid data/lm/valid
fi

log "Successfully finished. [elapsed=${SECONDS}s]"

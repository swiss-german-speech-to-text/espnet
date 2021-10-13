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
    mkdir -p data/spc
    local/data_prep.pl downloads/spc "train_0.9" data/spc/train_09
    local/data_prep.pl downloads/spc "train_0.7" data/spc/train_07
    local/data_prep.pl downloads/spc "train_all" data/spc/train_all
    local/data_prep.pl downloads/spc "test" data/spc/test

    # TODO prepare bern_stadtrat as well as dev sets

    # TODO merge with bern_stadtrat
    utils/combine_data.sh --extra_files utt2num_frames data/train data/spc/train_09 data/spc/train_09
    utils/combine_data.sh --extra_files utt2num_frames data/dev data/spc/train_09 data/spc/train_09
fi

log "Successfully finished. [elapsed=${SECONDS}s]"

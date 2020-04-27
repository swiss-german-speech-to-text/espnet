#!/bin/bash

# Copyright 2020 Johns Hopkins University (Shinji Watanabe)
#  Apache 2.0  (http://www.apache.org/licenses/LICENSE-2.0)

. ./path.sh || exit 1;
. ./cmd.sh || exit 1;
. ./db.sh || exit 1;

# general configuration
stage=1      # start from 0 if you need to start from data preparation
stop_stage=100
SECONDS=0
raw_data_de="downloads/common_voice"
raw_data_ch_train="downloads/swisstext2020/train"
raw_data_ch_test="downloads/swisstext2020/test"

. parse_options.sh

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
    mkdir -p ${raw_data_de}
    mkdir -p ${raw_data_ch_train}
    mkdir -p ${raw_data_ch_test}
    local/download_and_untar.sh ${raw_data_de} https://voice-prod-bundler-ee1969a6ce8178826482b88e843c335139bd3fb4.s3.amazonaws.com/cv-corpus-3/de.tar.gz de.tar.gz
    wget https://drive.switch.ch/index.php/s/PpUArRmN5Ba5C8J/download?path=%2F&files=train.zip -O ${raw_data_ch_train}/train.zip
    wget https://drive.switch.ch/index.php/s/PpUArRmN5Ba5C8J/download?path=%2F&files=test.zip -O ${raw_data_ch_test}/test.zip
    (cd ${raw_data_ch_train} && unzip train.zip)
    (cd ${raw_data_ch_test} && unzip test.zip)
fi

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    log "stage 2: Preparing data: downloads -> data"
    ### Task dependent. You have to make data the following preparation part by yourself.
    ### But you can utilize Kaldi recipes in most cases
    local/data_prep.pl ${raw_data_de} "validated" data/de_train
    local/data_prep.pl ${raw_data_ch_train} "data" data/ch_train_dev
    #local/data_prep.pl ${raw_data_ch_test} "data" data/ch_test FIXME transform text data so we can use it

    # split ch train data into train and dev
    ./utils/subset_data_dir_tr_cv.sh data/ch_train_dev data/ch_train data/ch_dev

    # combine de train and ch train
    utils/combine_data.sh data/de_ch_train data/de_train data/ch_train
fi

log "Successfully finished. [elapsed=${SECONDS}s]"

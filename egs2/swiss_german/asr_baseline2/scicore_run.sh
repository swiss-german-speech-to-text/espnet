#!/bin/bash
#SBATCH --job-name=espnet_egs2_swiss_german_baseline2
#SBATCH --time=7-00:00:00
#SBATCH --cpus-per-task=40
#SBATCH --ntasks=1
#SBATCH --mem=800G
#SBATCH --qos=1week
#SBATCH --partition=a100
#SBATCH -o scicore_out/%A_%a.out
#SBATCH -e scicore_out/%A_%a.err
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

./run.sh

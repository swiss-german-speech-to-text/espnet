#Installation
based on https://espnet.github.io/espnet/installation.html

##Ubuntu
sudo apt-get install python3.7 python3.7-dev libfreetype6-dev

##Scicore 
ml CMake/3.15.3-GCCcore-8.3.0
ml SoX/14.4.2-GCCcore-8.3.0
ml libsndfile/1.0.28-GCCcore-8.3.0
ml FFmpeg/.4.2.1-GCCcore-8.3.0
ml FLAC/1.3.3-GCCcore-8.3.0
ml cuDNN/8.1.0.77-CUDA-11.2.1
ml Python/3.7.4-GCCcore-8.3.0

##All
git clone https://github.com/espnet/espnet
cd espnet/tools
./setup_venv.sh python3.7
make TH_VERSION=1.9.0 CUDA_VERSION=11.1

./activate_python.sh; python3 check_install.py

##Run
base on https://espnet.github.io/espnet/tutorial.html
cd egs2/swiss_german/asr_baseline1

##Ubuntu
./run.sh

##Scicore
sbatch  scicore_run.sh


# Generate Results:
<!-- /utils/show_result.sh -->
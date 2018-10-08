#!/bin/bash

# install CUDA Toolkit v9.0
# instructions from https://developer.nvidia.com/cuda-downloads (linux -> x86_64 -> Ubuntu -> 16.04 -> deb)
CUDA_REPO_PKG="cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb"
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/${CUDA_REPO_PKG}
sudo dpkg -i ${CUDA_REPO_PKG}
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda-9-0

CUDA_PATCH1="cuda-repo-ubuntu1604-9-0-local-cublas-performance-update_1.0-1_amd64-deb"
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/1/${CUDA_PATCH1}
sudo dpkg -i ${CUDA_PATCH1}
sudo apt-get update

# install cuDNN v7.0
CUDNN_PKG="libcudnn7_7.0.5.15-1+cuda9.0_amd64.deb"
wget https://github.com/ashokpant/cudnn_archive/raw/master/v7.0/${CUDNN_PKG}
sudo dpkg -i ${CUDNN_PKG}
sudo apt-get update

# install NVIDIA CUDA Profile Tools Interface ( libcupti-dev v9.0)
sudo apt-get install cuda-command-line-tools-9-0

# set environment variables
export PATH=${PATH}:/usr/local/cuda-9.0/bin
export CUDA_HOME=${CUDA_HOME}:/usr/local/cuda:/usr/local/cuda-9.0
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-9.0/lib64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64

#install Anaconda3 5.2.0
wget https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
bash Anaconda3-5.2.0-Linux-x86_64.sh 
source .bashrc

#jupyter-notebook
jupyter notebook --generate-config
printf "c = get_config()\nc.NotebookApp.ip = '*'\nc.NotebookApp.open_browser = False\nc.NotebookApp.port=5000\nc.NotebookApp.token=''" >> .jupyter/jupyter_notebook_config.py
printf "#jupyter\nalias jupyter-notebook='jupyter-notebook --no-browser --port=5000'">> .bashrc
source .bashrc

#git
git config --global alias.conf 'config --global'
git conf alias.st 'status'
git conf alias.com 'commit -m'
git conf alias.all 'log --oneline --graph --all'
git conf push.default simple

#gcsfuse
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install gcsfuse

#gcutils
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-218.0.0-linux-x86_64.tar.gz
tar zxvf google-cloud-sdk-218.0.0-linux-x86_64.tar.gz google-cloud-sdk
./google-cloud-sdk/install.sh

# adding external libraries
pip install --upgrade pip
pip install msgpack
pip install tensorflow-gpu
pip install keras
pip install git+https://www.github.com/keras-team/keras-contrib.git
pip install theano
pip install sklearn
conda install pytorch torchvision -c pytorch
pip install tsfresh




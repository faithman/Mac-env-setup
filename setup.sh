#!/bin/bash
# Daniel E. Cook
# Run with: 
# 
set -e
rm -rf ~/.linuxbrew
rm -rf ~/.cache
rm -rf ~/R

# Get machine

git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
PATH="$HOME/.linuxbrew/bin:$PATH"


brew install pyenv autojump nextflow

pyenv install -s 2.7.11
pyenv install -s 3.6.0
pyenv install -s miniconda3-4.3.27

pyenv local miniconda3-4.3.27
conda config --add channels conda-forge
conda config --add channels bioconda

conda env create --name primary-seq-env --file primary-seq-env.base.yaml


pyenv local miniconda3-4.3.27/envs/primary-seq-env miniconda3-4.3.27/envs/vcf-kit miniconda3-4.3.27
pyenv global miniconda3-4.3.27/envs/primary-seq-env miniconda3-4.3.27/envs/vcf-kit miniconda3-4.3.27
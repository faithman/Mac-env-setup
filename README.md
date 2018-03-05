# conda-env

The conda environment files are designed to be used with [pyenv](https://github.com/pyenv/pyenv).

```
# Install linuxbrew

#
brew install pyenv

# Install the primary-seq-env.yaml
conda create --file primary-seq-env.yaml

# Install the vcf-kit.yaml environment
conda create --file vcf-kit.yaml
```


## Installing

```
conda env create --file primary-seq-env.yaml
conda env create --file vcf-kit.yaml
```

## pyenv config

```
pyenv global miniconda3-4.3.27/envs/primary-seq-env miniconda3-4.3.27/envs/vcf-kit miniconda3-4.3.27
```
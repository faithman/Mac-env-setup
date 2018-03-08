# andersen-lab


# Pull the latest repo for the andersen lab environment
cd && if cd ~/andersen-lab-env; then git pull; else git clone http://www.github.com/andersenlab/andersen-lab-env; fi



The conda environment files are designed to be used with [pyenv](https://github.com/pyenv/pyenv).

```
# Install linuxbrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

#
brew install pyenv

# Install the primary-seq-env.yaml
conda create --file primary-seq-env.yaml

# Install the py2.yaml environment
conda create --file py2.yaml
```

```
cecho "Installing homebrew dependencies" green
brew tap brewsci/science
brew install pyenv pyenv-virtualenv autojump nextflow tree
```

## Installing

```
conda env create --file primary-seq-env.yaml
conda env create --file py2.yaml
```

## pyenv config

```
pyenv global miniconda3-4.3.27/envs/primary-seq-env miniconda3-4.3.27/envs/py2 miniconda3-4.3.27
```

# Environment types

In this repo you will find base environments and versioned environments. Base environments are used to update versioned environments

#### Base Environments

Base environments have a `.base` suffix before the extension and are intended to be __manually__ edited. The base environment specifies all the software to be installed. If new software packages are required they should be added to the base environment.

* `primary-seq-env.base.yaml`
* `py2.base.yaml`

#### Versioned Environments

Versioned environments explicitly define software versions and are what is used to install software for use with pipelines. The versioned environments
are platform specific and have the following pattern:

`[platform].[env].yaml`

Currently these two environments are:

* `primary-seq-env.yaml`
* `py2.yaml`

# Updating environments

In order to make the installation proces quick environments are explicitly versioned. Updates can be made by modifying the original environments which end with `.environment.yaml` and regenerating the platform (linux/mac) environment versions of each environment.

For the `py2` environment the bam-toolbox requirement will need to be manually updated in the exported environment.

__All changes to environment files need to be reflected in the git history of this repo__.

```
# Create the base environment (use if this is the first time you are creating the environment)
conda env create --name primary-seq-env --file primary-seq-env.base.yaml

# Update the base enviornment after adding a new piece of software
conda env update --name primary-seq-env --file primary-seq-env.base.yaml

# Export the environment to a precisely defined version.
# If you have updated any packages version changes will be reflected here.
conda env export --name primary-seq-env > primary-seq-env.yaml
```
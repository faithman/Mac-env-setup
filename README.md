# andersen-lab

The conda environment files are designed to be used with [pyenv](https://github.com/pyenv/pyenv).

```
# Install linuxbrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

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

# Environment types

In this repo you will find base environments and versioned environments. Base environments are used to update versioned environments

#### Base Environments

Base environments have a `.base` suffix before the extension and are intended to be __manually__ edited. Base environments rarely indicate specific versions for software, and are used to generate the versioned environments.

* `primary-seq-env.base.yaml`
* `vcf-kit.base.yaml`

#### Versioned Environments

Versioned environments explicitly define software versions and are what is used to install software for use with pipelines.

* `primary-seq-env.yaml`
* `vcf-kit.yaml`

# Updating environments

For updates to programs already installed within the environment it is okay to update the versioned environment manually. You can also add software programs but you must add an explicit version number to the versioned environment and the program name without a version to the base environment.

Occasionally it may be appropriate to regenerate the versioned environment with the most up to date versions of all software. To do this you should remove the existing environment and recreate it. Then use the recreated environment to generated a versioned environment YAML file.

__All changes to environment files need to be reflected in the git history of this repo__

```
# Create the base environment (use if this is the first time you are creating the environment)
conda env update --name primary-seq-env --file primary-seq-env.base.yaml

# Update the base enviornment after adding a new piece of software
conda env update --name primary-seq-env --file primary-seq-env.base.yaml

# Export the environment to a precisely defined version.
# If you have updated any packages version changes will be reflected here.
conda env export --name primary-seq-env > primary-seq-env.yaml
```
#!/bin/bash
# Daniel E. Cook

# Ask user if they want to replace their bash profile right away
read -n 1 -r -p "Do you want to replace your bash profile? [y/n] " response < /dev/tty

# Set options
set -e
set -x

DATE="2018-03-09"
CONDA_VERSION="miniconda3-4.3.27"

# Get machine
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

function cecho(){
    local exp=$1;
    local color=$2;
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput setaf $color;
    echo $exp;
    tput sgr0;
}

# Install homebrew dependencies
if ! [ -x "$(command -v brew)" ]; then
    cecho "Please install homebrew or linuxbrew"
    exit 1;
fi;

# Install homebrew dependencies
brew bundle

# Initialize pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

cecho "Installing python environments" green
pyenv install -s ${CONDA_VERSION}
pyenv local ${CONDA_VERSION}

cecho "Creating conda environments" green

for environment_name in primary py2; do
    pyenv uninstall -f ${environment_name}-${DATE}
    pyenv virtualenv --force ${CONDA_VERSION} ${environment_name}-${DATE}
    conda env update --prune --name=${environment_name}-${DATE} --file=versions/${machine}.${DATE}.${environment_name}.yaml
done;

cecho "Install bam-toolbox"
pyenv local py2-${DATE}
pyenv rehash
pip install --no-deps https://github.com/AndersenLab/bam-toolbox/archive/0.0.3.tar.gz

cecho "Exporting conda environments" green
mkdir -p ~/.conda_environment
conda env export  --name  primary-${DATE} > ~/.conda_environment/primary-${DATE}.yaml
conda env export  --name  py2-${DATE} > ~/.conda_environment/py2-${DATE}.yaml

# Expand global environment
pyenv local ${CONDA_VERSION}/envs/primary-${DATE} ${CONDA_VERSION}/envs/py2-${DATE} ${CONDA_VERSION}
pyenv global ${CONDA_VERSION}/envs/primary-${DATE} ${CONDA_VERSION}/envs/py2-${DATE} ${CONDA_VERSION}

pyenv rehash

# Install R packages
cecho "Installing cegwas" green
echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
echo "options(unzip = 'internal');" >> ~/.Rprofile
Rscript -e 'devtools::install_github("andersenlab/cegwas", upgrade_dependencies=FALSE)'

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    cecho 'Replacing bash profile'
    curl -s https://raw.githubusercontent.com/AndersenLab/andersen-lab-env/master/user_bash_profile.sh > ~/.bash_profile
else
    cecho 'Copy this (or the parts you want) to your bash profile'
    cecho '------------------------------------------------------'
    curl -s https://raw.githubusercontent.com/AndersenLab/andersen-lab-env/master/user_bash_profile.sh
    cecho '------------------------------------------------------'
fi

if [ "${machine}" == "Mac" ]; then
    cecho "Installation completed" green
    say "Installation complete. Skynet has been activated. Have a great day."
fi;

exec bash
source ~/.bash_profile


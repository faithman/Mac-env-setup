#!/bin/bash
# Daniel E. Cook
# Run with: 
# curl -s https://raw.githubusercontent.com/AndersenLab/andersen-lab-env/master/setup.sh | bash


# Ask user if they want to replace their bash profile right away
read -n 1 -r -p "Do you want to replace your bash profile? [y/n] " response < /dev/tty

DATE=`date +%Y-%m-%d`

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


if ! [ -x "$(command -v brew)" ]; then
    if [ "${machine}" == "Mac" ]; then
        cecho "Please install homebrew" red
        exit 1
    else
        git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
        PATH="$HOME/.linuxbrew/bin:$PATH"
    fi;
fi;


# Set options
set -e
set -x


cecho "Installing homebrew dependencies" green
brew tap brewsci/science
PACKAGES="pyenv autojump nextflow tree"
for p in $(brew list); do
    PACKAGES=${PACKAGES//$p/}
done;

if [ ! -z "${PACKAGES// }" ]; then
    brew install ${PACKAGES}
fi;

cecho "Installing python environments" green
pyenv install -s 2.7.14
pyenv install -s 3.6.0
pyenv install -s miniconda3-4.3.27

pyenv local miniconda3-4.3.27
conda config --add channels conda-forge
conda config --add channels bioconda

cecho "Creating conda environments" green

curl -s https://raw.githubusercontent.com/AndersenLab/andersen-lab-env/master/primary.environment.yaml > primary.environment.yaml
curl -s https://raw.githubusercontent.com/AndersenLab/andersen-lab-env/master/py2.environment.yaml > py2.environment.yaml
conda env create --force --name primary-${DATE} --file primary.environment.yaml
conda env create --force --name py2-${DATE} --file py2.environment.yaml

pyenv global miniconda3-4.3.27/envs/primary-${DATE} miniconda3-4.3.27/envs/py2-${DATE} miniconda3-4.3.27

# Install R packages
cecho "Installing cegwas" green
echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
Rscript -e 'devtools::install_github("andersenlab/cegwas")'

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    cecho 'Replacing bash profile'
    curl https://raw.githubusercontent.com/AndersenLab/andersen-lab-env/master/user_bash_profile.sh > ~/.bash_profile
else
    cecho 'Copy this (or the parts you want) to your bash profile'
    cecho '------------------------------------------------------'
    curl https://raw.githubusercontent.com/AndersenLab/andersen-lab-env/master/user_bash_profile.sh
    cecho '------------------------------------------------------'
fi

if [ "${machine}" -eq "Mac" ]; then
    cecho "Installation completed" green
    say "Installation complete. Skynet has been activated. Have a great day."
fi;

source ~/.bash_profile
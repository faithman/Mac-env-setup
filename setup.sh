#!/bin/bash
# Daniel E. Cook
# Run with: 
# curl https://raw.githubusercontent.com/AndersenLab/andersen-lab-env/master/setup.sh | bash


# Ask user if they want to replace their bash profile right away
read -n 1 -r -p "Do you want to replace your bash profile? [y/n] " response

# Set options
set -e
set -x
rm -rf ~/.linuxbrew
rm -rf ~/.cache
rm -rf ~/R

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
    if [ "${machine}" -eq "Mac" ]; then
        cecho "Please install homebrew" red
        exit 1
    else
        git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
        PATH="$HOME/.linuxbrew/bin:$PATH"
    fi;
fi;

cecho "Installing homebrew dependencies" green
brew tap brewsci/science
brew install pyenv autojump nextflow autojump tree

cecho "Installing python environments" green
pyenv install -s 2.7.14
pyenv install -s 3.6.0
pyenv install -s miniconda3-4.3.27

pyenv local miniconda3-4.3.27
conda config --add channels conda-forge
conda config --add channels bioconda

cecho "Creating conda environments" green
conda env create --name primary-seq-env --file primary-seq-env.yaml
conda env create --name py2 --file py2.yaml

pyenv global miniconda3-4.3.27/envs/primary-seq-env miniconda3-4.3.27/envs/py2 miniconda3-4.3.27

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

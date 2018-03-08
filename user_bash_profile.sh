#!/bin/bash
export HOMEBREW_EDITOR=nano
export PS1='\[\e[0;35m\][\h::\w] 🏀 \[\e[m\] '
export PATH="$HOME/.linuxbrew/bin:~/google-cloud-sdk/bin:$PATH"
export MANPATH="$(brew --prefix)/share/man:$MANPATH"
export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# go work - Go to the working directoy. Copy the hash that nextflow outputs and this function
gw() {
    cd /projects/b1042/AndersenLab/work/$1*
}
rm_gw() {
    rm -rf /projects/b1042/AndersenLab/work/$1*
}

# Autojump config
[ -f "/home/$(whoami)/.linuxbrew/etc/profile.d/autojump.sh" ] && . "/home/$(whoami)/.linuxbrew/etc/profile.d/autojump.sh"

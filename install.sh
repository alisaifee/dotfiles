#!/usr/bin/env bash
function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ]; then
        mv $target $target.bak
    fi

    ln -sf ${source} ${target}
}
if [ ! -e ~/.oh-my-zsh ]; then
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi;
if [ ! -e ~/.emacs.d ]; then
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d;
fi;

if [ "$1" = "vim" ]; then
    sudo bundle install 
    sudo npm -g install 
    for i in _vim*
    do
       link_file $i
    done
elif [ "$1" = "zsh" ]; then
    for i in _zsh*
    do 
        link_file $i
    done
else
    for i in _*
    do
        if [ $i != "_config" ]; then
            link_file $i
        fi;
    done
    for i in _config/*
    do
        ln -sf ${PWD}/$i ~/.config/$name ;
    done;

fi

git submodule sync
git submodule init
git submodule update
git submodule foreach git pull origin master
git submodule foreach git submodule init
git submodule foreach git submodule update
pushd .

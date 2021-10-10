#!/usr/bin/env bash
function link_file() {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ]; then
        if [ -L "${target}" ]; then
            unlink $target
        else
            mv $target $target.bak
        fi
    fi

    ln -sf ${source} ${target}
}

function patch_fonts() {
    if [[ $(uname) == 'Darwin' ]]; then
        font_dir="$HOME/Library/Fonts"
    else
        font_dir="$HOME/.local/share/fonts"
    fi
    pushd /var/tmp
    curl -Lv https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -O FiraCode.zip
    unzip -o FiraCode.zip -d firacode
    cp firacode/* $font_dir
    popd
    cp ./fonts/patched/* $font_dir
}

# ensure config directory exists
mkdir -p ~/.config

if [ "$1" == "bootstrap" ]; then
    # mac specific bootstrap
    if [[ $(uname) == 'Darwin' ]]; then
        if [ ! $(command -v brew) ]; then
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        brew tap homebrew/cask-versions
        brew install cmake autoconf ctags-exuberant node-build ruby-build coreutils wget unison readline jq xz ripgrep reattach-to-user-namespace entr
        brew install grep gawk vim tmux

        # Terminal
        brew cask install kitty

        # Yabai, Spacebar & Skhd
        brew install koekeishiya/formulae/yabai
        brew install somdoron/formulae/spacebar
        brew install koekeishiya/formulae/skhd

        brew cask install java
        brew cask install firefox
        brew cask install google-backup-and-sync
        brew cask install whatsapp
        brew cask install cloudapp
        brew cask install jetbrains-toolbox
        brew cask install keybase
        brew cask install istat-menus

        # lameness for python builds to find openssl
        export CFLAGS="-I$(brew --prefix openssl)/include"
        export LDFLAGS="-L$(brew --prefix openssl)/lib"
    else
        sudo apt update
        # development deps
        sudo apt -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6 \
            libreadline6-dev zlib1g zlib1g-dev libffi-dev libgdbm-dev ruby-dev libnurses5 libncurses5-dev
        # development tools
        sudo apt -y install gnupg2 gnupg
        sudo apt -y install openjdk-8-jre
        sudo apt -y install postgresql postgresql-contrib libpq-dev
        sudo apt -y install mysql-server mysql-client libmysqlclient-dev
        sudo apt -y install memcached redis-server
        sudo apt -y install nginx
        sudo apt -y install awscli
        sudo apt -y install jq
        sudo apt -y install keychain zsh vim-nox curl tmux exuberant-ctags entr
        if [ !$(command -v rustup) ]; then
            curl https://sh.rustup.rs -sSf | sh -s -- -y
        fi
        cargo install ripgrep
        cargo install exa
        cargo install fd
        cargo install bat
        cargo install hyperfine
        cargo install git-delta
        cargo install starship

    fi

    patch fonts

    if [ ! -e ~/antigen.zsh ]; then
        curl -L git.io/antigen >~/antigen.zsh
    fi

    # make the virtualenvs available in bash
    export PATH=$PATH:~/.pyenv/bin/:~/.rbenv/bin/:~/.nodenv/bin/
    eval "$(pyenv init -)"
    eval "$(rbenv init -)"
    eval "$(nodenv init -)"

    # tmuxinator
    if [ ! "$(type tmuxinator)" ]; then
        sudo gem install tmuxinator
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        export PYTHON_CONFIGURE_OPTS="--enable-framework"
    else
        export PYTHON_CONFIGURE_OPTS="--enable-shared"
    fi
elif [ "$1" = "vim" ]; then
    for i in _vim*; do
        link_file $i
    done
    git submodule init
    git submodule update --init --recursive

    if [ -z "$(command -v fzf)" ]; then
        pushd .
        cd _vim/bundle/fzf && ./install
        popd
    fi
    pushd .
    cd _vim/bundle/YouCompleteMe
    ./install.py
    popd
elif [ "$1" = "zsh" ]; then
    for i in _zsh*; do
        link_file $i
    done
else
    for i in _*; do
        if [ $i != "_config" ]; then
            link_file $i
        fi
    done
    for i in _config/*; do
        link_file $i
    done
fi

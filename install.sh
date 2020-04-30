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

function install_i3_gaps() {
    pushd .
    cd /var/tmp
    if [ ! -e i3-gaps ]; then
        git clone https://github.com/Airblader/i3 i3-gaps
    fi
    cd i3-gaps
    git pull
    sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
        libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev \
        libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev \
        libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake \
        gnome-fallback fontforge
    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    sudo make install
    pushd +3
}

function install_rofi() {
    pushd .
    cd /var/tmp/
    sudo apt-get install -y flex libjson-glib-dev
    if [ ! -e rofi ]; then
        git clone --recursive https://github.com/davatorium/rofi
    fi
    cd rofi
    git pull
    git submodule update --init
    autoreconf -i
    mkdir build && cd build
    ../configure --disable-check
    sudo make install
    pushd +2
    if [ ! -e rofi-blocks ]; then
        git clone git@github.com:fogine/rofi-blocks.git
    fi
    cd rofi-blocks
    git pull
    git checkout next
    autoreconf -i
    mkdir -p build && cd build
    ../configure
    make
    sudo make install
    pushd +3
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
        brew install cmake ctags-exuberant node-build ruby-build coreutils wget unison readline jq xz ripgrep reattach-to-user-namespace
        brew install grep
        brew install gawk
        brew install vim
        brew install tmux

        # Terminal
        brew cask install kitty

        # Yabai, Spacebar & Skhd
        brew install koekeishiya/formulae/yabai
        brew install somdoron/formulae/spacebar
        brew install koekeishiya/formulae/skhd

        brew cask install java8
        brew cask install google-chrome slack

        # lameness for python builds to find openssl
        export CFLAGS="-I$(brew --prefix openssl)/include"
        export LDFLAGS="-L$(brew --prefix openssl)/lib"
    else
        if [ ! -e /etc/apt/sources.list.d/elastic-5.x.list ]; then
            wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
            sudo apt-get install apt-transport-https
            echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
        fi
        sudo apt-get update
        sudo apt-get -y install keychain zsh vim-nox curl tmux ctags-exuberant cargo
        # window manager
        sudo apt-get install -y dunst py3status i3
        install_i3_gaps
        # development deps
        sudo apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libffi-dev libgdbm-dev ruby-dev libnurses5 libncurses5-dev
        sudo apt-get -y install gnupg2 gnupg
        sudo apt-get -y install openjdk-8-jre
        sudo apt-get -y install postgresql postgresql-contrib libpq-dev
        sudo apt-get -y install mysql-server mysql-client libmysqlclient-dev
        sudo apt-get -y install memcached redis-server
        sudo apt-get -y install nginx
        sudo apt-get -y install awscli
        sudo apt-get -y install elasticsearch
        sudo apt-get -y install jq
        cargo install ripgrep
    fi

    # patch fonts
    patch_fonts
    if [ ! -e ~/antigen.zsh ]; then
        curl -L git.io/antigen >~/antigen.zsh
    fi

    if [ ! -e ~/.rbenv ]; then
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
        mkdir -p "$(rbenv root)"/plugins
        git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
    fi
    if [ ! -e ~/.pyenv ]; then
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    fi
    if [ ! -e ~/.pyenv/plugins/pyenv-virtualenv ]; then
        git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
    fi
    if [ ! -e ~/.nodenv ]; then
        git clone https://github.com/nodenv/nodenv.git ~/.nodenv
        git clone https://github.com/nodenv/nodenv-aliases.git ~/.nodenv/plugins/nodenv-aliases
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
    # default pythons
    for version in 2.7.17 3.7.7 3.8.2; do
        if [ ! -e ~/.pyenv/versions/$version ]; then
            pyenv install $version
        fi
    done

    # default rubies
    for version in 2.5.3 2.6.1; do
        if [ ! -e ~/.rbenv/versions/$version ]; then
            rbenv install $version
        fi
    done

    # default nodes
    nodenv alias --auto
    for version in 10.19.0 13.11.0; do
        nodenv install $version
    done
    nodenv global 13
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

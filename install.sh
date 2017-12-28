#!/usr/bin/env bash
function link_file {
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

function add_watch {
    if [ -L $1 ]; then
        path=$(readlink $1);
    else
        path="$1";
    fi;
    friendly_name=$(echo $1 | sed -E -e "s#$HOME##g" -e 's/[^A-Za-z]//g')_trigger;
    watchman trigger-del $path $friendly_name;
    watchman -j <<-EOT
    [
        "trigger", "$path", {
            "name": "$friendly_name",
            "expression": ["anyof", ["pcre", ".(cc|clj|coffee|cpp|cs|css|dart|el|erb|erl|ex|exs|go|gradle|groovy|hpp|htm|html|hxx|java|js|jsx|json|lua|php|py|rake|rb|sass|scala|scss|slim|spec|sql|vb|vim|xhtml|xml)$"]],"command": ["$HOME/_dev/_git/dotfiles/bin/ctags_trigger", "$path"],
            "append_files": true
        }
    ]
EOT
}

function install_i3_gaps {
    pushd .
    cd /var/tmp
    if [ ! -e i3-gaps ]; then
        git clone https://github.com/Airblader/i3 i3-gaps;
    fi
    cd i3-gaps
    git pull
    sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake
    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    sudo make install
    popd
}

function patch_fonts {
    if [[ `uname` == 'Darwin' ]]
    then
        brew cask search nerd-font | xargs -n 1 brew cask install
    else
        pushd .
        cd /var/tmp
        if [ ! -e nerd-fonts ];then
            git clone https://github.com/ryanoasis/nerd-fonts --depth 1
        fi;
        cd nerd-fonts
        git pull
        ./install.sh
        popd
fi
}


# ensure config directory exists
mkdir -p ~/.config

# mac specific bootstrap
if [[ `uname` == 'Darwin' ]]
then
    if [ ! "$(type brew)" ]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    brew tap caskroom/fonts
    brew install ctags-exuberant ruby-build coreutils wget unison readline xz watchman ripgrep
    # homebrew vim
    brew install vim --with-lua --with-python3

    # temporary workaround as tmux 2.5 isn't supported by tmuxinator
    brew install https://raw.githubusercontent.com/Homebrew/brew/2d2034afc6e4dfab0a1c48f5edd2c5478576293b/Formula/tmux.rb

    # All the fonts!
    brew cask search powerline | xargs -n 1 brew cask install
    # sigh
    brew cask install java
    # lameness for python builds to find openssl
    export CFLAGS="-I$(brew --prefix openssl)/include"
    export LDFLAGS="-L$(brew --prefix openssl)/lib"
else
    if [ ! -e /etc/apt/sources.list.d/elastic-5.x.list ];
    then
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -;
        sudo apt-get install apt-transport-https;
        echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list;
    fi;
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
    cargo install ripgrep
fi

# patch fonts
patch_fonts

# set up oh-my-zsh
if [ ! -e ~/.oh-my-zsh ]; then
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi;

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
if [ ! -e ~/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash
fi

# make the virtualenvs available in bash
export PATH=$PATH:~/.pyenv/bin/:~/.rbenv/bin/
eval "$(pyenv init -)"
eval "$(rbenv init -)"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# tmuxinator
if [ ! "$(type tmuxinator)" ]; then
    sudo gem install tmuxinator
fi

# default pythons
for version in 3.5.4 2.7.11; do
    if [ ! -e ~/.pyenv/versions/$version ]; then
        pyenv install $version;
    fi
done;

# default rubies
for version in 2.4.2; do
    if [ ! -e ~/.rbenv/versions/$version ]; then
        rbenv install $version;
    fi
done

# default nodes
nvm install 6.3
nvm install stable
nvm alias default 6.3

# install watches
#for path in ~/_sync ~/_dev ~/.pyenv ~/.rbenv; do
#    add_watch $path
#done;

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

git submodule init
git submodule update --recursive

# compile command-t
if [ -e "_vim/bundle/command-t/ruby" ]; then
    pushd .
    cd _vim/bundle/command-t/ruby/command-t/ext/command-t
    make clean
    ruby extconf.rb
    make
    popd
fi;

if [ -z "$(command -v fzf)" ]; then
    pushd .
    cd _vim/bundle/fzf && ./install
    popd
fi;

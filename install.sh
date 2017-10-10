#!/usr/bin/env bash
function linkFile {
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

function addWatch {
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

# set up oh-my-zsh
if [ ! -e ~/.oh-my-zsh ]; then
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi;

# ensure config directory exists
mkdir -p ~/.config

# mac specific bootstrap
if [[ `uname` == 'Darwin' ]]
then
    if [ ! "$(type brew)" ]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    if [ ! -e ~/.rbenv ]; then
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
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
    brew tap caskroom/fonts
    brew install ctags-exuberant ruby-build coreutils wget unison readline xz watchman
    # homebrew vim
    brew install vim --with-lua

    # temporary workaround as tmux 2.5 isn't supported by tmuxinator
    brew install https://raw.githubusercontent.com/Homebrew/brew/2d2034afc6e4dfab0a1c48f5edd2c5478576293b/Formula/tmux.rb

    # All the fonts!
    brew cask search powerline | xargs -n 1 brew cask install
    # sigh
    brew cask install java
    # lameness for python builds to find openssl
    export CFLAGS="-I$(brew --prefix openssl)/include"
    export LDFLAGS="-L$(brew --prefix openssl)/lib"
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
for version in 2.3.3 2.4.2; do
    if [ ! -e ~/.rbenv/versions/$version ]; then
        rbenv install $version;
    fi
done

# default nodes
nvm install 6.3
nvm install stable
nvm alias default 6.3

# install watches
for path in ~/_sync ~/_dev ~/.pyenv ~/.rbenv; do
    addWatch $path
done;

if [ "$1" = "vim" ]; then
    sudo bundle install
    sudo npm -g install
    for i in _vim*
    do
       linkFile $i
    done
elif [ "$1" = "zsh" ]; then
    for i in _zsh*
    do
        linkFile $i
    done
else
    for i in _*
    do
        if [ $i != "_config" ]; then
            linkFile $i
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

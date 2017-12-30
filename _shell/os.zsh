if [[ `uname` == 'Linux' ]];
then
    /usr/bin/keychain -q $HOME/.ssh/id_rsa
    source $HOME/.keychain/`hostname`-sh
    eval `dircolors ~/.dircolors`
else
    eval `gdircolors ~/.dircolors`
    alias ctags="`brew --prefix`/bin/ctags"
    if [ -n "$TMUX" ];
    then
        alias terminal-notifier='reattach-to-user-namespace terminal-notifier'
        alias ssh='reattach-to-user-namespace ssh'
    fi;
fi;

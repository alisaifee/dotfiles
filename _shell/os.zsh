if [[ `uname` == 'Linux' ]];
then
    /usr/bin/keychain -q $HOME/.ssh/id_rsa
    source $HOME/.keychain/`hostname`-sh
    eval `dircolors ~/.dircolors`
    alias copy='xclip -selection clipboard'
    alias paste='xclip -o -selection clipboard'
else
    eval `gdircolors ~/.dircolors`
    alias ctags="`brew --prefix`/bin/ctags"
    if [ -n "$TMUX" ];
    then
        alias terminal-notifier='reattach-to-user-namespace terminal-notifier'
        alias ssh='reattach-to-user-namespace ssh'
    fi;
    alias copy='pbcopy'
    alias paste='pbpaste'
fi;

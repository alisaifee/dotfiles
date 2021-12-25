if [[ $(uname) == 'Linux' ]]; then
    if type "keychain" >/dev/null 2>&1; then
        /usr/bin/keychain -q $HOME/.ssh/id_rsa
        source $HOME/.keychain/$(hostname)-sh
    fi
    eval $(dircolors ~/.dircolors)
    alias copy='xclip -selection clipboard'
    alias paste='xclip -o -selection clipboard'
    alias open='xdg-open'
else
    eval $(gdircolors ~/.dircolors)
    alias ctags="$(brew --prefix)/bin/ctags"
    if [ -n "$TMUX" ]; then
        alias terminal-notifier='reattach-to-user-namespace terminal-notifier'
        alias ssh='reattach-to-user-namespace ssh'
    fi
    alias copy='pbcopy'
    alias paste='pbpaste'
fi

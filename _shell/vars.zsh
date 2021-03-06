export ZENV=zsh
export ZENV=prezto
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME=agnoster
export EDITOR=vim
export TERM=xterm-256color
export LC_ALL=en_US.UTF-8
export LANG=en_US.utf8
export GPG_TTY=$(tty)
unsetopt nomatch
[ -f ~/.shell/secrets.zsh ] && source ~/.shell/secrets.zsh

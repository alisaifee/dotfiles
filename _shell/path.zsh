export PYTHONPATH=$PYTHONPATH:~/.vim/bundle/powerline:~/.vim/bundle/powerline_mem_segment
export PYENV_ROOT="$HOME/.pyenv"
export NODENV_ROOT="$HOME/.nodenv"
path=( $NODENV_ROOT/bin $path)
path=( $PYENV_ROOT/bin $path)
path=( $PYENV_ROOT/shims $path)
path=( ~/bin $path)
path=( /usr/local/bin $path)
path=( /usr/local/sbin $path)
path=( $HOME/.rbenv/bin $path)
path=( $path ~/.vim/bundle/powerline/scripts)
path=( ~/.cargo/bin $path)

typeset -aU path
if type "go" > /dev/null 2>&1; then
    export GOPATH=~/gohome
    export GOROOT=$(go env GOROOT)
fi

path=( $GOPATH/bin $path)
path=( $GOROOT/bin $path)

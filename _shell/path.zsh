export PYENV_ROOT="$HOME/.pyenv"
export NODENV_ROOT="$HOME/.nodenv"
path=($NODENV_ROOT/bin $path)
path=($PYENV_ROOT/bin $path)
path=($HOME/.rbenv/bin $path)
path=($HOME/.cargo/bin $path)
if type "go" > /dev/null 2>&1; then
    export GOPATH=~/gohome
    export GOROOT=$(go env GOROOT)
    path+=$GOPATH/bin
    path+=$GOROOT/bin
fi
path=(/usr/local/opt/coreutils/libexec/gnubin $path)
path=(~/bin $path)

manpath=(/usr/local/opt/coreutils/libexec/gnuman $manpath)

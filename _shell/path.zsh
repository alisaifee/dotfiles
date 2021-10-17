path=($HOME/.cargo/bin $path)
path=(/usr/local/opt/coreutils/libexec/gnubin $path)
path=(/usr/local/opt/grep/libexec/gnubin $path)
path=(~/bin $path)
path=(${KREW_ROOT:-$HOME/.krew}/bin $path)
manpath=(/usr/local/opt/coreutils/libexec/gnuman $manpath)
manpath=(/usr/local/opt/grep/libexec/gnuman $manpath)
if type "go" > /dev/null 2>&1; then
    export GOPATH=~/gohome
    path=(~/gohome/bin $path)
fi

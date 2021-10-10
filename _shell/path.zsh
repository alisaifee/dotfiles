path=($HOME/.cargo/bin $path)
if type "go" > /dev/null 2>&1; then
    export GOPATH=~/gohome
    export GOROOT=$(go env GOROOT)
    path=(~/gohome/bin $path)
fi
path=(/usr/local/opt/coreutils/libexec/gnubin $path)
path=(/usr/local/opt/grep/libexec/gnubin $path)
path=(~/bin $path)

manpath=(/usr/local/opt/coreutils/libexec/gnuman $manpath)
manpath=(/usr/local/opt/grep/libexec/gnuman $manpath)

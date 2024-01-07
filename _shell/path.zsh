path=($HOME/.cargo/bin $path)
if [[ $(uname) == 'Linux' ]]; then
    path=($path "$(/home/aliakber.saifee/.linuxbrew/bin/brew --prefix)/bin")
else
    path=(/usr/local/opt/coreutils/libexec/gnubin $path)
    path=(/usr/local/opt/grep/libexec/gnubin $path)
    manpath=(/usr/local/opt/coreutils/libexec/gnuman $manpath)
    manpath=(/usr/local/opt/grep/libexec/gnuman $manpath)
fi
if type "go" > /dev/null 2>&1; then
    export GOPATH=~/gohome
    path=(~/gohome/bin $path)
fi
path=(~/bin $path)

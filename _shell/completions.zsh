autoload -U +X compinit
compinit
fpath=(${ASDF_DIR}/completions $fpath)
for cmd in kubectl tilt snooctl; do
  if type $cmd > /dev/null 2>&1;
  then
    source <(exec $cmd completion zsh)
    compdef _$cmd $cmd
  fi;
done;

autoload -U +X compinit
compinit
fpath=(${ASDF_DIR}/completions $fpath)
source <(kubectl completion zsh)

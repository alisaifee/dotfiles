autoload -U +X compinit
compinit
fpath=(~/.oh-my-zsh/cache/completions ${ASDF_DIR}/completions $(brew --prefix)/share/zsh/site-functions $fpath)


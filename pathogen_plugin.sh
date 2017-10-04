#!/bin/zsh

git submodule add https://github.com/$1 _vim/bundle/$1:t
git submodule init

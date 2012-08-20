#!/bin/bash

FILES="colordiffrc environment gitconfig gitignore tmux.conf zshrc"

cd $HOME

git clone git@github.com:voldmar/dotfiles etc

for file in $FILES
do
    ln -s etc/$file .$file
done

touch .zshrc_local


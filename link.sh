#!/bin/bash

FILES="colordiffrc environment gitconfig gitignore tmux.conf zshrc"

REALPATH=$(python -c "import os.path as p; print p.dirname(p.realpath('$0'))")

for file in $FILES
do
    ln -s $REALPATH/$file $HOME/.$file
done


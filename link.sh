#!/bin/bash

FILES="ackrc colordiffrc environment gitconfig gitignore tmux.conf zshrc"

REALPATH=$(python -c "import os.path as p; print p.dirname(p.realpath('$0'))")

[[ -n $FORSE ]] && FLAGS=-f

for file in $FILES
do
    ln -s $FLAGS $REALPATH/$file $HOME/.$file
done


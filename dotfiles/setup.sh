#!/bin/bash

# go to script directory
cd "$( dirname "${BASH_SOURCE[0]}" )"

# make symlinks
files=$(ls -1d .[!.]*)
for f in $files; do
    ln -s $PWD/$f ~/$f
done

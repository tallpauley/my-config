#!/bin/bash

# go to repo directory
pushd $(dirname $0) > /dev/null
THIS_DIR=$PWD
popd > /dev/null

# make symlinks
for f in $THIS_DIR/dotfiles/.[!.]*; do
  ln -s $f ~/$(basename $f)
done

#!/bin/bash

# go to repo directory
pushd $(dirname $0) > /dev/null
THIS_DIR=$PWD
popd > /dev/null

# make symlinks for dotfiles
for f in $THIS_DIR/dotfiles/.[!.]*; do
  ln -s $f ~/$(basename $f)
done

# symlink VSCode files
for f in $THIS_DIR/vscode/User/*; do
  ln -s $f ~/Library/Application\ Support/Code/User/$(basename $f)
done

# install VSCode extensions
cat $THIS_DIR/vscode/extensions.txt | while read -r e; do
  code --install-extension $e
done

#!/bin/bash

SUBLIME_USER_DIR='/Users/cmpauley/Library/Application Support/Sublime Text 3/Packages/User'

# go to script directory
cd "$( dirname "${BASH_SOURCE[0]}" )"

# rm existing sublime user directory
rm -rf "$SUBLIME_USER_DIR"

# make folder symlink (sublime directory points here)
ln -s $PWD "$SUBLIME_USER_DIR"

# make subl available on path
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

SHELL = /bin/bash

ALL: help

.PHONY: help
help:
	@echo Makefile Help:
	@echo
	@echo make install
	@echo "   Symlink dotfiles and vscode config, and install vscode extensions"
	@echo make dotfiles
	@echo "   Symlink dotfiles"
	@echo make vscode-symlinks
	@echo "   Symlink vscode config"
	@echo make vscode-extensions
	@echo "   Install vscode extensions from extensions.txt"
	@echo make vscode-extensions-codify
	@echo "   Write vscode extensions to extensions.txt"
	@echo make install-python
	@echo "   Install latest Python with Homebrew"


.PHONY: install
install: dotfiles ssh-config vscode-symlinks vscode-extensions

# make symlinks for dotfiles
.PHONY: dotfiles
dotfiles:
	for f in dotfiles/*; do \
  		ln -sf $$PWD/$$f ~/.$$(basename $$f); \
	done

.PHONY: ssh-config
ssh-config:
	ln -sf $$PWD/ssh_config ~/.ssh/config

# symlink VSCode config
.PHONY: vscode-symlinks
vscode-symlinks:
	for f in vscode/User/*; do \
		ln -sf $$PWD/$$f $(HOME)/Library/Application' 'Support/Code/User/$$(basename $$f); \
	done

# install VSCode extensions from extensions.txt
.PHONY: vscode-extensions
vscode-extensions:
	cat vscode/extensions.txt | while read -r e; do \
		code --install-extension $$e; \
	done

# Write VSCode extensions to extensions.txt
.PHONY: vscode-extensions-codify
vscode-extensions-codify:
	code --list-extensions > vscode/extensions.txt

# Get latest Python (requires brew)
.PHONY: install-python
install-python:
	brew install python3
	brew postinstall python3

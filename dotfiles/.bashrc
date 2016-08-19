#!/usr/bin/env bash

# colors
alias less='less -r'
alias tree='tree -C'
alias grep="grep --color=auto"

# assorted aliases
alias erc="vi ~/.bashrc && . ~/.bashrc"
alias h="cd ~"

# ls aliases
alias sortbysize="ls -s | sort -n"

if [[ "$OSTYPE" == "linux"* ]]; then
  alias ls='ls --color=auto'
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls='ls -GF'
fi

alias ll='ls -l'
alias la='ls -al'

# tmux
alias tmn='tmux new -s'
alias tma='tmux attach -t'

# googler
alias g="googler -n 3"

# git
alias gc="git commit -m "
alias gp="git push"
alias gl="git pull --rebase"
alias gs="git status -s"
alias ga="git add"
alias glo="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias gd="git diff"
alias gds="git diff --staged"

# color codes (for prompt)
black='\[\033[0;30m\]'
red='\[\033[0;31m\]'
green='\[\033[0;32m\]'
yellow='\[\033[0;33m\]'
cyan='\[\033[0;36m\]'
white='\[\033[1;37m\]'
grey='\[\033[0;37m\]'
reset='\[\033[0m\]'

# borrowed successful command prompt code from https://coderwall.com/p/d2vlqq/show-last-command-s-status-in-bash-prompt
function BashPrompt() {
    local last_status=$?

    local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if git status > /dev/null 2>&1; then
      if git diff-index --quiet HEAD > /dev/null 2>&1; then
        local git_changed_count=" $(git diff --numstat | wc -l | tr -d ' ')"
      fi
      if ! test -z "$(git ls-files --exclude-standard --others)"; then
        local git_untracked=" u"
      fi
      local git_section="${yellow}[${grey}${current_branch}${red}${git_changed_count}${green}${git_untracked}${yellow}]${reset} "
    fi
    local time=$(date +"%T")

    if [[ "$last_status" == "0" ]]; then
      local time_color=$green
    else
      local time_color=$red
    fi

    echo "${time_color}[\t]${reset} ${git_section}\u@\h ${cyan}${PWD/$HOME/~}${reset} "
}

# the hook which updates the prompt whenever we run a command
PROMPT_COMMAND='PS1=$(BashPrompt)'

# history
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL="ignoreboth"

# fancy d function for changing dirs
function d() { 
  # show stack if no param
  local param=$1
  if [ -z "$param" ]; then
    dirs -v | sed "1d"
    return
  fi
 
  # change dir if param isn't number
  re='^[0-9]+$'
  if ! [[ $param =~ $re ]] ; then
    cd $param
    pushd $PWD > /dev/null
    ls
    return
  fi

  # if $param is number switch to dir on stack
  # we are looking to see if $PWD is any but last entry in stack
  # if it isn't there, push it so we have it
  # dirs -v | sed '1d' 
  # if [[ $? != 0 ]]; then
  # dirs -v | sed '1d' | grep "${PWD/$HOME/~}" -q
  #   pushd $PWD
  #   # increment line if we push onto stack
  #   line=$((param+1))
  # fi

  # switch to dir indicated by number
  local line=$((param+1))
  dir=$(dirs -v | sed "${line}q;d" | awk '{print $2}')
  # not sure why I need this still, tilde wasn't expanding as it was
  eval dir=$dir
  cd $dir
  ls
}

# colors
alias less='less -r'
alias tree='tree -C'
alias grep="grep --color=auto"

# assorted aliases
alias erc="vi ~/.bashrc && . ~/.bashrc"
alias h="cd ~"
alias sb="subl"

# ls aliases
alias sortbysize="ls -s | sort -n"

if [[ "$OSTYPE" == "linux"* ]]; then
  alias ls='ls --color=auto'
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls='ls -GF'
fi

alias l='ls'
alias ll='ls -l'
alias la='ls -al'

# tmux
alias tmn='tmux new -s'
alias tma='tmux attach -t'

# googler
alias g="googler -n 3"

# git alias helpers
function add_commit() {
  git add $1;
  git commit -m "$2";
}

# sublime aliases
alias s="subl"

# docker aliases
alias dp="docker ps"
alias dpa="docker ps -a"
alias dpe="docker ps --filter status=exited"
alias dr="docker rm"
alias drf="docker rm -f"
drl() { docker rm $(docker ps -ql); } 
drle() { docker rm $(docker ps -ql --filter status=exited); } 
drfl() { docker rm -f $(docker ps -ql); } 
alias drf="docker rm -f"

# git aliases
alias gc="git commit -m"
alias gac="add_commit"
alias gch="git checkout"
alias gp="git push"
alias gl="git pull --rebase"
alias gs="git status -s"
alias ga="git add"
alias glo="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias gd="git diff"
alias gds="git diff --staged"
alias gsu="git status -uno"
alias gb="git blame"

# google cloud & kubernetes aliases
alias gcl="gcloud"
alias kl="kubectl"

# include brew completion files
# works w/ `brew install git-completion`
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# all other completion files
if [ -d ~/.bash_completion.d ]; then
    for i in ~/.bash_completion.d/*; do
      . $i
    done
fi

# color codes (for prompt)
black='\[\033[0;30m\]'
red='\[\033[0;31m\]'
green='\[\033[0;32m\]'
yellow='\[\033[0;33m\]'
cyan='\[\033[0;36m\]'
white='\[\033[1;37m\]'
grey='\[\033[0;37m\]'
reset='\[\033[0m\]'

# tiny git status for use in BashPrompt
function GitStatus() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if git status > /dev/null 2>&1; then
      if ! git diff-index --quiet HEAD > /dev/null 2>&1; then
        local staged="$(git diff --cached --numstat | wc -l | tr -d ' ')"
        if [[ $staged != 0 ]]; then
          git_staged_count=" $staged"
        fi

        local modified="$(git diff --numstat | wc -l | tr -d ' ')"
        if [[ $modified != 0 ]]; then
          git_modified_count=" $modified"
        fi
      fi
      local untracked="$(git ls-files --exclude-standard --others | wc -l | tr -d ' ')"
      if [[ $untracked != 0 ]]; then
        git_untracked_count=" $untracked"
      fi
      echo "[${grey}${current_branch}${green}${git_staged_count}${red}${git_modified_count}${yellow}${git_untracked_count}${reset}] "
    fi
}

# borrowed successful command prompt code from https://coderwall.com/p/d2vlqq/show-last-command-s-status-in-bash-prompt
function BashPrompt() {
    local last_status=$?
    local time=$(date +"%T")

    if [[ "$last_status" == "0" ]]; then
      local time_color=$green
    else
      local time_color=$red
    fi

    local git_section="$(GitStatus)"

    echo "${time_color}\t${reset} ${git_section}\u@\h ${cyan}${PWD/$HOME/~}${reset} "
}

# the hook which updates the prompt whenever we run a command
PROMPT_COMMAND='PS1=$(BashPrompt)'

# general
# turn off ctrl-d sending EOF (thus quitting terminal)
set -o ignoreeof

# extglob (for !(*stuff) syntax)
shopt -s extglob

# allow Ctrl+s
stty -ixon

# editor
export EDITOR=vim

# history
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL="ignoreboth"

# file to store paths in for switcher
dirsfile=~/.dirs

# fancy directory switcher
d() {
  # displays numbered paths in $dirsfile if no params
  if [ -z "$1" ]; then
    if [ -f $dirsfile ]; then
      nl -b a $dirsfile | tail -r
      return
    fi
  fi

  # clear all dirs if -c
  if [[ "$1" == '-c' ]]; then
    > $dirsfile
    return
  fi

    # remove dir on line if -r
  if [[ "$1" == '-r' ]]; then
    sed -i '.bak' "${2}d" $dirsfile
    return
  fi

    # go to root of git repo
  if [[ "$1" == '-g' ]]; then
    cd $(git rev-parse --show-toplevel)
      if [[ "$OSTYPE" == "linux"* ]]; then
          ls --color=auto
      elif [[ "$OSTYPE" == "darwin"* ]]; then
          ls -GF
      fi
    return
  fi

  # switches to a directory and adds to $dirsfile if param is path
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    cd $1 || return
    echo "${PWD/$HOME/~}" >> $dirsfile
    ls
    return
  fi

  # switches to path with displayed number if param is number
  dir=$(sed "${1}q;d" $dirsfile)
  eval dir=$dir
  cd $dir
  ls
}

alias vi="code"

# shortcut for returning to git root
alias dg="d -g"

# colors
alias less='less -r'
alias tree='tree -C'
alias grep="grep --color=auto"

# assorted aliases
alias erc="vi ~/.bashrc && . ~/.bashrc"
alias h="history | grep"

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

# atom aliases
alias c="code"

# docker aliases
alias dc="docker-compose"
alias dlc="docker ps -lq"
alias dp="docker ps"
alias dpa="docker ps -a"
alias dpe="docker ps --filter status=exited"
alias drf="docker rm -f"
drl() { docker rm $(docker ps -ql); }
drle() { docker rm $(docker ps -ql --filter status=exited); }
drfl() { docker rm -f $(docker ps -ql); }
alias drf="docker rm -f"

# git aliases
alias gc="git commit -m"
alias gac="add_commit"
alias gca="git commit --amend"
alias gcam="git commit -am"
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
alias gcla="gcloud config configurations activate"
alias gclc="gcloud compute"
alias gclssh="gcloud compute ssh"
alias gcli="gcloud compute instances list"

# helper function, if number gets pod id from line number of kubctl get pods
# or just returns input if already a pod id
get_pod() {
  re='^[0-9]+$'
  if [[ $1 =~ $re ]] ; then
    kubectl get pods | sed '1d' | sed -n "${1}p" | awk '{print $1}'
    return
  fi
  echo $1
}
alias k="kubectl"
alias kp="kubectl get pods | sed '1d' | nl -w 2 "

alias kubectl_sys="kubectl --namespace='kube-system'"
kl() { kubectl logs $(get_pod $1); }
klp() { kubectl logs -p $(get_pod $1); }
klf() { kubectl logs -f $(get_pod $1); }
kdp() { kubectl describe pod $(get_pod $1); }
kssh() { kubectl exec -it $(get_pod $1) sh; }

alias kwp="watch -d kubectl get pods"
kwd() { watch -d kubectl describe pod $(get_pod $1); }

alias kg="kubectl get"
alias kd="kubectl describe"

# include brew completion files
# works w/ `brew install git-completion`
if brew -v > /dev/null 2>&1 && [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

# all other completion files
if [ -d ~/.bash_completion.d ]; then
  for i in ~/.bash_completion.d/*; do
    . $i
  done
fi

# color codes (for prompt)
black='\[\e[30m\]'
red='\[\e[31m\]'
green='\[\e[32m\]'
lightgreen='\[\e[92m\]'
yellow='\[\e[33m\]'
cyan='\[\e[36m\]'
lightcyan='\[\e[96m\]'
white='\[\e[37m\]'
magenta='\[\e[35m\]'
lightmagenta='\[\e[95m\]'
grey='\[\e[37m\]'
black='\[\e[30m\]'
reset='\[\e[0m\]'
red_bg="\[\e[41m\]"
lightred_bg="\[\e[101m\]"
green_bg="\[\e[42m\]"
lightgreen_bg="\[\e[102m\]"
blue_bg="\[\e[44m\]"
yellow_bg="\[\e[43m\]"
lightyellow_bg="\[\e[103m\]"
magenta_bg='\[\e[45m\]'
lightgrey_bg="\[\e[100m\]"

# tiny git status for use in BashPrompt
function GitStatus() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if git status > /dev/null 2>&1; then
    if ! git diff-index --quiet HEAD > /dev/null 2>&1; then
      local staged="$(git diff --cached --numstat | wc -l | tr -d ' ')"
      if [[ $staged != 0 ]]; then
        git_staged_count=" $staged "
      fi

      local modified="$(git diff --numstat | wc -l | tr -d ' ')"
      if [[ $modified != 0 ]]; then
        git_modified_count=" $modified "
      fi
    fi
    local untracked="$(git ls-files --exclude-standard --others | wc -l | tr -d ' ')"
    if [[ $untracked != 0 ]]; then
      git_untracked_count=" $untracked "
    fi
    echo "${blue_bg}${black} ${current_branch} ${reset}${green_bg}${black}${git_staged_count}${red_bg}${git_modified_count}${yellow_bg}${git_untracked_count}${reset}"
  fi
}

# borrowed successful command prompt code from https://coderwall.com/p/d2vlqq/show-last-command-s-status-in-bash-prompt
function BashPrompt() {
  local last_status=$?
  local time=$(date +"%T")

  if [[ "$last_status" == "0" ]]; then
    local time_color=$green_bg$black
  else
    local time_color=$red_bg$black
  fi

  local git_section="$(GitStatus)"

  echo "${time_color} \t ${reset}${git_section} ${cyan}\u@${cyan}\h ${white}${PWD/$HOME/~}${reset} "
}

# the hook which updates the prompt whenever we run a command
PROMPT_COMMAND='PS1=$(BashPrompt)'

# work-specific rc file
if [ -f ~/.bashrc_private ]; then
    source ~/.bashrc_private
fi

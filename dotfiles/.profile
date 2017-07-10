export TERM='xterm-256color'

export PATH="$PATH:~/code/go/bin"
export PATH="~/bin:$PATH"
export GOPATH=~/code/go

# keychain
eval `keychain --eval`

# work-specific profile file
if [ -f ~/.bash_profile_private ]; then
  source ~/.bash_profile_private
fi

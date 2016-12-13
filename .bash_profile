# Uncomment to debug slow performance
# set -x
# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"
export EDITOR="vim"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'
export THEME_SHOW_CLOCK_CHAR=false

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt
STACK_COMPILER_BIN=$HOME/.stack/programs/x86_64-osx/ghc-7.10.3/bin
PYTHON_HOME=$HOME/Library/Python/2.7
PATH=$HOME/.rbenv/bin:$HOME/.local/bin:$STACK_COMPILER_BIN:$PYTHON_HOME/bin:$PATH

# Load Bash It
source $BASH_IT/bash_it.sh

# Load Rbenv
eval "$(rbenv init -)"

# Load direnv
eval "$(direnv hook bash)"

# Aliases
alias cdws="cd ~/workspace"

# Auto completion
source $HOME/.git-completion

tmux2host() {
  if [ $# -ne 2  ]; then
    echo 'Incorrect usage'
    echo "usage: tmux2host user host-ip"
    return 1
  fi

  user=$1
  host=$2
  ssh $1@$host -t "bash -l -c \"tmux new\""
}

# Source local bash configuration if present
if [ -e $HOME/.bash_profile.local ]; then
  source $HOME/.bash_profile.local
fi


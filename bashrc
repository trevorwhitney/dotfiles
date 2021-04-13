# Uncomment to debug slow performance
# set -x

### Themes
export THEME_SHOW_CLOCK_CHAR=false
# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

source $HOME/.themes/base.theme.bash
source $HOME/.themes/colors.theme.bash
source $HOME/.themes/bobby.theme.bash

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

export JAVA_HOME='/usr/lib/jvm/default-java/'

export XDG_CONFIG_HOME=$HOME/.config

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt
STACK_COMPILER_BIN=$HOME/.stack/programs/x86_64-osx/ghc-7.10.3/bin

export PYTHON_HOME=/usr/lib/python2.7

export GOPATH=$HOME/workspace/gocode

RBENV_ROOT=$HOME/.rbenv
PYENV_ROOT=$HOME/.pyenv
PATH=$GOPATH/bin:$RBENV_ROOT/bin:$PYENV_ROOT/bin:$HOME/bin:$HOME/.local/bin:$STACK_COMPILER_BIN:$PYTHON_HOME/bin:/usr/local/go/bin:$PATH

# Load Rbenv
[ `which rbenv` ] && eval "$(rbenv init -)"

# Load direnv
[ `which direnv` ] && eval "$(direnv hook bash)"

# Load pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
[ `which pyenv` ] && eval "$(pyenv init -)"
[ `which pyenv-virtualenv-init` ] && eval "$(pyenv virtualenv-init -)"

# Aliases
for file in `ls $HOME/aliases.d`; do
  source $HOME/aliases.d/$file
done

# Auto completion
for file in `ls $HOME/bash_completion.d`; do
  source $HOME/bash_completion.d/$file
done

tmux2host() {
  if [ $# -eq 2  ]; then
    user=$1
    host=$2
    ssh $1@$host -t "bash -l -c \"tmux new\""
  elif [ $# -eq 1 ]; then
    host=$1
    ssh $host -t "bash -l -c \"tmux new\""
  else
    echo 'Incorrect usage'
    echo "usage: tmux2host [user] host-ip"
    return 1
  fi
}

# Source local bash configuration if present
if [ -e $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi



[ -f ~/.fzf.bash ] && source ~/.fzf.bash

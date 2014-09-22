# source bash profile.d
# (to disable a profile, just remove execute permission on it)
for profile in /etc/profile.d/*.sh; do
  if [ -x $profile ]; then
    . $profile
  fi
done
unset profile

export JAVA_HOME="/opt/java/jdk/current"
export GOPATH="$HOME/gospace"
export GOROOT="/usr/local/go"
export GOBIN="$GOPATH/bin"

# set PATH
PATH="$JAVA_HOME/bin:$PATH"
PATH="$GOBIN:$PATH:$GOROOT/bin"
PATH="$HOME/.cask/bin:$PATH"
PATH="$HOME/.rbenv/bin:$PATH"
PATH="$HOME/.rbenv/shims:$PATH"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="arrow"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git ruby rails bundler rake gem heroku)

source $ZSH/oh-my-zsh.sh

# automatically cd to folders
setopt autocd

# turn off autocorrect
# unsetopt correct_all

# initialize rbenv
eval "$(rbenv init -)"

# set Solarized dircolors
eval `dircolors ~/.dircolors`

# alias some commands

# fix keys
# xmodmap ~/Xmodmap

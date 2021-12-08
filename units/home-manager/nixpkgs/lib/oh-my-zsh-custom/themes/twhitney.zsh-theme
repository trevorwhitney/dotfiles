# vim:ft=zsh ts=2 sw=2 sts=2
#
# Based on agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](https://iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# If using with "light" variant of the Solarized color schema, set
# SOLARIZED_THEME variable to "light". If you don't specify, we'll assume
# you're using the "dark" variant.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts
#
### Colors
CURRENT_BG='NONE'
black="#002b36"
blue="#268bd2"
bright_white="#fdf6e3"
white="#eee8d5"
cyan="#2aa198"
gray="#586e75"
green="#859900"
magenta="#d33682"
red="#dc322f"
violent="#6c71c4"
yellow="#b58900"

case ${BACKGROUND:-light} in
  dark)
    CURRENT_FG="$bright_white"
    prompt_fg="$black"
    mode_bg="$gray"
    ;;
  *)
    CURRENT_FG="$black"
    prompt_fg="$bright_white"
    mode_bg="$white"
    ;;
esac

# Special Powerline characters

() {
local LC_ALL="" LC_CTYPE="en_US.UTF-8"
# NOTE: This segment separator character is correct.  In 2012, Powerline changed
# the code points they use for their special characters. This is the new code point.
# If this is not working for you, you probably have an old version of the
# Powerline-patched fonts installed. Download and install the new version.
# Do not submit PRs to change this unless you have reviewed the Powerline code point
# history and have new information.
# This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
# what font the user is viewing this source code in. Do not replace the
# escape sequence with a single literal character.
# Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
SEGMENT_SEPARATOR=$'\ue0b0'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  # Only show this if SSH'd into remote machine
  if [[ -n "$SSH_CLIENT" ]]; then
    prompt_segment $cyan $prompt_fg "%(!.%{%F{yellow}%}.)%n@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path

  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment $yellow $prompt_fg
    else
      prompt_segment $green $prompt_fg
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

# Dir: current working directory
prompt_dir() {
  # prompt_segment cyan $CURRENT_FG '%~'
  prompt_segment $blue $prompt_fg '%2~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment $blue $prompt_fg "(`basename $virtualenv_path`)"
  fi
}

prompt_time() {
  if [[ $RETVAL -eq 0 ]]; then
    prompt_segment $violent $prompt_fg '%*'
  else
    prompt_segment $red $prompt_fg '%*'
  fi
}


# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local -a symbols

  # this info is being covered in time now
  # [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment $mode_bg $CURRENT_FG "$symbols"
}

#AWS Profile:
# - display current AWS_PROFILE name
# - displays yellow on red if profile name contains 'production' or
#   ends in '-prod'
# - displays black on green otherwise
prompt_aws() {
  [[ -z "$aws_profile" || "$show_aws_prompt" = false ]] && return
  case "$aws_profile" in
    *-prod|*production*) prompt_segment $red $prompt_fg  "aws: $aws_profile" ;;
    *) prompt_segment $green $prompt_fg "aws: $aws_profile" ;;
  esac
}

# current k8s context
prompt_k8s() {
  #Only show if kubectl is installed
  if [[ $(command -v kubectl) ]]; then
    #Only show if there is a context
    context="$(kubectl config view -ojson | jq -r '."current-context"')"
    if [[ -n "$context" ]]; then
      context="$(kubectl config current-context || echo "-")"
      prompt_segment $violent $prompt_fg "$context"
    fi
	fi
}

prompt_vi_mode() {
  case $KEYMAP in
    vicmd) prompt_segment $magenta $prompt_fg normal;;
    viins|main) prompt_segment $mode_bg $CURRENT_FG ✎;;
  esac
}

prompt_ret_val() {
  if [[ $RETVAL -ne 0 ]]; then
    prompt_segment $red $prompt_fg $RETVAL
  fi
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_ret_val
  # time was moved to the right side prompt
  # prompt_time
  prompt_status
  prompt_virtualenv
  prompt_aws
  prompt_context
  prompt_k8s
  prompt_dir
  prompt_git
  prompt_vi_mode
  prompt_end
}

RPS1="$EPS1 %{$fg_bold[blue]%}[%*]%{$reset_color%}"
PROMPT='%{%f%b%k%}$(build_prompt) '

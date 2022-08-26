# vim:ft=zsh ts=2 sw=2 sts=2
#
### Colors
black="#002b36"
blue="#268bd2"
white="#eee8d5"
cyan="#2aa198"
gray="#586e75"
green="#859900"
magenta="#d33682"
red="#dc322f"
violet="#6c71c4"
yellow="#b58900"

base03="#002b36"
base02="#073642"
base01="#586e75"
base00="#657b83"
base0="#839496"
base1="#93a1a1"
base2="#eee8d5"
base3="#fdf6e3"

case ${BACKGROUND:-light} in
  dark)
    CURRENT_FG="$base3"
    prompt_fg="$base00"
    mode_bg="$gray"
    ;;
  *)
    CURRENT_FG="$base03"
    prompt_fg="$base0"
    mode_bg="$white"
    ;;
esac

# Special Powerline characters

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  fg="%F{$1}"
  echo -n "%{$fg%}"
  echo -n "$2 "
  echo -n "%{%B%}$3%{%f%}%{%b%}"

}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  # Only show this if SSH'd into remote machine
  if [[ -n "$SSH_CLIENT" ]]; then
    prompt_segment $violet 歷 "%(!.%{%F{yellow}%}.)%n@%m"
    print_separator
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  local ref dirty mode repo_path

  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
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

    print_separator

    info="${ref/refs\/heads\//}${vcs_info_msg_0_%% }${mode}"
    if [[ -n $dirty ]]; then
      prompt_segment $yellow  $info
    else
      prompt_segment $green  $info
    fi

  fi
}

# Dir: current working directory
prompt_dir() {
  if [[ $RETVAL -ne 0 ]]; then
    prompt_segment $red  '%2~'
  else
    prompt_segment $blue  '%2~'
  fi
}

# current k8s context
prompt_k8s() {
  #Only show if kubectl is installed
  if [[ $(command -v kubectl) ]]; then
    #Only show if there is a context
    context="$(kubectl config view -ojson | jq -r '."current-context"')"
    if [[ -n "$context" ]]; then
      prompt_segment $cyan  "$context"
      print_separator
    fi
	fi
}

print_separator() {
  echo -n " %{%F{$base1}%}|%{%f%} "
}

prompt() {
  local mode
  case $KEYMAP in
    vicmd) mode="%{%F{$magenta}%}normal%{%B%}>%{%F{$CURRENT_FG}%b%}";;
    viins|main) mode="%{%F{$blue}%B%}>%{%F{$CURRENT_FG}%b%}";;
  esac
  echo -n "$mode"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_context
  prompt_k8s
  prompt_dir
  prompt_git
  echo -n "\n"
  prompt
  echo -n "%{%f%k%}"
}


PROMPT='%{%f%b%k%}$(build_prompt) '

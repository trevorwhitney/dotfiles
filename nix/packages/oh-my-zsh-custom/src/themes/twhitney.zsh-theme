# vim:ft=zsh ts=2 sw=2 sts=2
#
### Colors
case ${THEME:-flexoki} in
  solarized)
    ## Solarized colors
    black="#100F0F"
    white="#eee8d5"
    gray="#586e75"

    blue="#268bd2"
    cyan="#2aa198"
    green="#859900"
    magenta="#d33682"
    red="#dc322f"
    violet="#6c71c4"
    yellow="#b58900"

    blue2="#268bd2"
    cyan2="#2aa198"
    gray2="#586e75"
    green2="#859900"
    magenta2="#d33682"
    red2="#dc322f"
    violet2="#6c71c4"
    yellow2="#b58900"

    yellow2="#657b83"
    base0="#839496"
    base1="#93a1a1"
    paper="#fdf6e3"
    ;;
  *)
    ## Flexoki colors
    black="#002b36"
    white="#F2F0E5"
    gray="#586e75"

    case ${BACKGROUND:-light} in
      dark)
        ## Flexoki dark
        blue="#4385BE"
        cyan="#3AA99F"
        green="#879A39"
        magenta="#CE5D97"
        red="#D14D41"
        violet="#8B7EC8"
        yellow="#D0A215"

        blue2="#205EA6"
        cyan2="#24837B"
        green2="#66800B"
        magenta2="#A02F6F"
        red2="#AF3029"
        violet2="#5E409D"
        yellow2="#AD8301"
        ;;
      *)
        ## Flexoki light
        blue="#205EA6"
        cyan="#24837B"
        green="#66800B"
        magenta="#A02F6F"
        red="#AF3029"
        violet="#5E409D"
        yellow="#AD8301"

        blue2="#4385BE"
        cyan2="#3AA99F"
        green2="#879A39"
        magenta2="#CE5D97"
        red2="#D14D41"
        violet2="#8B7EC8"
        yellow2="#D0A215"
        ;;
    esac

    base0="#6F6E69"
    base1="#878580"
    paper="#fdf6e3"
    ;;
esac

case ${BACKGROUND:-light} in
  dark)
    CURRENT_FG="$paper"
    prompt_fg="$yellow2"
    mode_bg="$gray"
    ;;
  *)
    CURRENT_FG="$black"
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
  echo -n "$2"
  [[ $# -gt 2 ]] && echo -n " %{%B%}$3%{%f%}%{%b%}"

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

# Show Icon if in Nix Shell
prompt_nix_shell() {
  # Only show this if SSH'd into remote machine
  if [[ -n "$IN_NIX_SHELL" ]]; then
    prompt_segment $violet 
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
  prompt_segment $blue  '%2~'
}

# Print failed return values
prompt_retval() {
  if [[ $RETVAL -ne 0 ]]; then
    prompt_segment $red  "$RETVAL"
    print_separator
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
    vicmd) mode="%{%F{$magenta}%}normal%{%B%}❯%{%F{$CURRENT_FG}%b%}";;
    viins|main) mode="%{%F{$blue}%B%}❯%{%F{$CURRENT_FG}%b%}";;
  esac
  echo -n "$mode"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_retval
  prompt_nix_shell
  prompt_context
  prompt_k8s
  prompt_dir
  prompt_git
  echo -n "\n"
  prompt
  echo -n "%{%f%k%}"
}


PROMPT='%{%f%b%k%}$(build_prompt) '

# vim:ft=zsh ts=2 sw=2 sts=2
#
### Colors
case ${THEME:-everforest} in
  everforest)
    case ${BACKGROUND:-light} in
      dark)
        ## everforest dark
        paper="#d3c6aa"
        black="#333c43"
        grey="#859289"

        blue="#7fbbb3"
        cyan="#83c092"
        green="#a7c080"
        magenta="#d699b6"
        red="#e67e80"
        violet="#d699b6"
        yellow="#dbbc7f"
        ;;
      *)
        ## everforest light
        paper="#f3ead3"
        black="#5c6a72"
        grey="#939f91"

        blue="#3a94c5"
        cyan="#35a77c"
        green="#8da101"
        magenta="#df69ba"
        red="#f8552"
        violet="#df69ba"
        # yellow="#dfa000"
        yellow="#D89B00"
        ;;
    esac
    ;;

  solarized)
    ## Solarized colors
    paper="#fdf6e3"
    black="#100F0F"
    gray="#586e75"

    blue="#268bd2"
    cyan="#2aa198"
    green="#859900"
    magenta="#d33682"
    red="#dc322f"
    violet="#6c71c4"
    yellow="#b58900"
    ;;

  flexoki)
    ## Flexoki colors
    paper="#fdf6e3"
    black="#002b36"
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
        ;;
    esac
    ;;
esac

case ${BACKGROUND:-light} in
  dark)
    CURRENT_FG="$paper"
    prompt_fg="$yellow"
    mode_bg="$gray"
    ;;
  *)
    CURRENT_FG="$black"
    prompt_fg="$grey"
    mode_bg="$paper"
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
    prompt_segment $violet 󰢩 "%(!.%{%F{yellow}%}.)%n@$(hostname -s)"
    print_separator
  fi
}

# Git: branch/detached head, dirty status
git_info() {
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

jjgit_prompt()
{
  pwd_in_jjgit() # echo "jj" or "git" if either is found in $PWD or its parent directories
  { # using the shell is much faster than `git rev-parse --git-dir` or `jj root`
    local D="/$PWD"
    while test -n "$D" ; do
      test -e "$D/.jj" && { echo jj ; return; }
      test -e "$D/.git" && { echo git ; return; }
      D="${D%/*}"
    done
  }

  local jjgit="`pwd_in_jjgit`"  # results in "jj", "git" or ""
  if test "$jjgit" = jj ; then
    # --ignore-working-copy: avoid inspecting $PWD and concurrent snapshotting which could create divergent commits
    info="$(jj --ignore-working-copy --no-pager log --no-graph --color=always -r @ -T \
       ' "[@ " ++ concat( separate(" ", format_short_change_id_with_hidden_and_divergent_info(self), format_short_commit_id(commit_id),
           bookmarks, description.trim(), if(conflict, label("conflict", "conflict")) ) ) ++ "]\n" ' 2>/dev/null)"
    print_separator
    echo -n " $info"
  elif test "$jjgit" = git ; then
    git_info
  fi
}

prompt_git() {
  jjgit_prompt
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
  echo -n " %{%F{$grey}%}|%{%f%} "
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
  prompt_context
  prompt_k8s
  prompt_dir
  prompt_git
  echo -n "\n"
  prompt
  echo -n "%{%f%k%}"
}


PROMPT='%{%f%b%k%}$(build_prompt) '

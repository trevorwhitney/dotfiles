# vim:ft=zsh ts=2 sw=2 sts=2
#
# Begin a segment
# Takes two arguments, foreground color and icon. Optional third arg is the text (rendered bold).
prompt_segment() {
  local fg
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
    prompt_segment magenta 󰢩 "%(!.%{%F{yellow}%}.)%n@$(hostname -s)"
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
      prompt_segment yellow  $info
    else
      prompt_segment green  $info
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
  prompt_segment blue  '%2~'
}

# Print failed return values
prompt_retval() {
  if [[ $RETVAL -ne 0 ]]; then
    prompt_segment red  "$RETVAL"
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
      prompt_segment cyan  "$context"
      print_separator
    fi
	fi
}

print_separator() {
  echo -n " %{%F{8}%}|%{%f%} "
}

prompt() {
  local mode
  case $KEYMAP in
    vicmd) mode="%{%F{magenta}%}normal%{%B%}❯%{%F{default}%b%}";;
    viins|main) mode="%{%F{blue}%B%}❯%{%F{default}%b%}";;
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

# vi: ft=nix
{ config, pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    autocd = false;
    enableAutosuggestions = true;
    defaultKeymap = "viins";
    oh-my-zsh = {
      enable = true;
      theme = "twhitney";
      plugins = [ "ruby" "vi-mode" "mvn" "aws" "docker" "docker-compose" ];
      custom = "${../lib/oh-my-zsh-custom}";
    };
    sessionVariables = {
      WORDCHARS = "*?_-.[]~=&;!#$%^(){}<>";
      HYPHEN_INSENSITIVE = "true";
      GLOBAL_GIT_HOOK_DIR="$HOME/.git/hooks";
      EDITOR="vim";
    };
      /* # Direnv hook */
      /* if [[ `command -v direnv` ]]; then */
      /*   eval "$(direnv hook zsh)" */
      /* fi */
    initExtra = (with pkgs; ''
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line

      bindkey -M viins 'jj' vi-cmd-mode

      # readline compatability
      bindkey -M viins '^P'  up-history
      bindkey -M viins '^N'  down-history
      bindkey -M viins '^?'  backward-delete-char
      bindkey -M viins '^[d' kill-word
      bindkey -M viins '^w'  backward-kill-word
      bindkey -M viins '^u'  backward-kill-line
      bindkey -M viins '^f'  forward-char
      bindkey -M viins '^b'  backward-char
      bindkey -M viins '^[f' forward-word
      bindkey -M viins '^[b' backward-word

      # needed for vi-mode indication in theme
      function zle-line-init zle-keymap-select {
      zle reset-prompt
      }

      zle -N zle-line-init
      zle -N zle-keymap-select

      export KEYTIMEOUT=17

      if [[ -e "$HOME/.cargo/env" ]]; then
        source "$HOME/.cargo/env"
      fi

      # completions
      complete -o nospace -C /usr/local/bin/tk tk
      complete -o nospace -C "$GOPATH/bin/gocomplete" go
      complete -o nospace -C /usr/bin/nomad nomad
      complete -o nospace -C /home/twhitney/workspace/k3d-sonnet/tool/k3dsonnet k3dsonnet

      autoload -U +X bashcompinit && bashcompinit

      # Fuzzy completion for history
      [ -f "${fzf}/share/fzf/completion.zsh" ] && source "${fzf}/share/fzf/completion.zsh" 
      [ -f "${fzf}/share/fzf/key-bindings.zsh" ] && source "${fzf}/share/fzf/key-bindings.zsh" 

      # Return the lowest numbered display in use by current user
      # which is usually what we want
      function get_default_display() {
        ps -u $(id -u) -o pid= \
          | xargs -I PID -r cat /proc/PID/environ 2> /dev/null \
          | tr '\0' '\n' \
          | grep -m1 -P '^DISPLAY=' \
          | sed -e 's/DISPLAY=//g'
      }

      # Needing for some copy/paste oddity with X11 forwarding
      if [[ `command -v tmux` ]] && [[ `tmux ls` ]]; then
        export TMUX_DISPLAY="$(tmux show-env | sed -n 's/^DISPLAY=//p')"
        # tmux clobbers our default DISPLAY env var, which reaks havoc
        # on copy/paste behavior in vim and terminal, so reset it when
        # tmux is active
        export DISPLAY="$(get_default_display)"
      fi

      if [[ "$BACKGROUND" == "dark" ]]; then
        export BAT_THEME="Solarized (dark)"
        export FZF_PREVIEW_PREVIEW_BAT_THEME="Solarized (dark)"
      else
        export BAT_THEME="Solarized (light)"
        export FZF_PREVIEW_PREVIEW_BAT_THEME="Solarized (light)"
      fi

      autoload -Uz compinit
      compinit -i

      if [[ `command -v kubectl` ]]; then
        source <(kubectl completion zsh)
        complete -F __start_kubectl k
      fi
          '');
  };
}

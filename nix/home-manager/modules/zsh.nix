# vi: ft=nix
{ config, pkgs, lib, ... }:
let
  custom = pkgs.oh-my-zsh-custom;
  cfg = config.programs.zsh;
in
{
  options = {
    programs.zsh = {
      use1Password = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "whether to include logic for the 1Password ssh agent";
      };
    };
  };

  config = {
    programs.zsh = {
      enable = true;
      autocd = false;
      enableAutosuggestions = true;
      defaultKeymap = "viins";
      enableCompletion = false;

      oh-my-zsh = {
        enable = true;
        theme = "twhitney";
        plugins = [ "ruby" "vi-mode" "mvn" "aws" "docker" "docker-compose" ];
        custom = "${custom}";
      };

      sessionVariables = {
        HYPHEN_INSENSITIVE = "true";
        KEYTIMEOUT = "17";
        NIX_LOG_DIR = "/nix/var/log/nix";
        NIX_STATE_DIR = "/nix/var/nix";
        NIX_STORE_DIR = "/nix/store";
        WORDCHARS = "*?_-.[]~=&;!#$%^(){}<>";
        ZSH_AUTOSUGGEST_STRATEGY = [ "history" "completion" ];
      };

      initExtra = builtins.concatStringsSep "\n" (with pkgs; [
        ''
          # Fuzzy completion for history
          [ -f "${fzf}/share/fzf/completion.zsh" ] && source "${fzf}/share/fzf/completion.zsh"
          [ -f "${fzf}/share/fzf/key-bindings.zsh" ] && source "${fzf}/share/fzf/key-bindings.zsh"

          # Use fd (https://github.com/sharkdp/fd) instead of the default find
          # command for listing path candidates.
          # - The first argument to the function ($1) is the base path to start traversal
          # - See the source code (completion.{bash,zsh}) for the details.
          _fzf_compgen_path() {
            fd --follow --no-ignore --hidden --exclude ".git" --exclude ".direnv" . "$1"
          }

          # Use fd to generate the list for directory completion
          _fzf_compgen_dir() {
            fd --type d --follow --no-ignore --hidden --exclude ".git" --exclude ".direnv" . "$1"
          }

          autoload -z edit-command-line
          zle -N edit-command-line
          bindkey "^X^E" edit-command-line

          bindkey -M viins 'jj' vi-cmd-mode

          # readline compatibility
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


          if [[ -e "$HOME/.cargo/env" ]]; then
            source "$HOME/.cargo/env"
          fi

          if [[ $(command -v luarocks) ]]; then
            eval "$(luarocks path --bin)"
          fi

          # Return the lowest numbered display in use by current user
          # which is usually what we want
          function get_default_display() {
            ps -u $(id -u) -o pid= \
              | xargs -I PID -r cat /proc/PID/environ 2> /dev/null \
              | tr '\0' '\n' \
              | grep -m1 -P '^DISPLAY=' \
              | sed -e 's/DISPLAY=//g'
          }

          # Needed for some copy/paste oddity with X11 forwarding
          # TODO: this doesn't work if there are multiple X servers, ie
          # sometimes you get 0 and 1, how do you pick between them?
          # if [[ `command -v tmux` ]] && [[ `tmux ls 2> /dev/null` ]]; then
          #   export TMUX_DISPLAY="$(tmux show-env | sed -n 's/^DISPLAY=//p')"
          #   # tmux clobbers our default DISPLAY env var, which reaks havoc
          #   # on copy/paste behavior in vim and terminal, so reset it when
          #   # tmux is active
          #   export DISPLAY="$(get_default_display)"
          # fi

          if [[ "$BACKGROUND" == "dark" ]]; then
            export BAT_THEME="Solarized (dark)"
            export FZF_PREVIEW_PREVIEW_BAT_THEME="Solarized (dark)"
            if [[ $TMUX_THEME == "everforest" ]]; then
              export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#d3c6aa,bg=#333c43"
            else
              # Solarized
              export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#586e75,bg=#002b36"
            fi
          else
            export BAT_THEME="Solarized (light)"
            export FZF_PREVIEW_PREVIEW_BAT_THEME="Solarized (light)"
            if [[ $TMUX_THEME == "everforest" ]]; then
              export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5c6a72,bg=#f3ead3"
            elif [[ $TMUX_THEME == "flexoki" ]]; then
              export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#575653,bg=#fffcf0"
            elif [[ $TMUX_THEME == "seoulbones" ]]; then
              export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#93a1a1,bg=#e2e2e2"
            else
              # Solarized
              export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#586e75,bg=#002b36"
            fi
          fi

          autoload -Uz compinit
          compinit -i

          source <(${pkgs.kubectl}/bin/kubectl completion zsh)
          complete -F __start_kubectl k

          # this path isn't there on nixos systems
          if [[ -e "$HOME/.nix-profile" ]]; then
            export NIX_PROFILE="$HOME/.nix-profile"
            . $NIX_PROFILE/etc/profile.d/hm-session-vars.sh
          fi

          PATH="$HOME/.local/bin:$PATH"

          autoload -U +X bashcompinit && bashcompinit
        ''
        (lib.optionalString cfg.use1Password
          ''
            if [ -z "$SSH_TTY" ]; then
              export SSH_AUTH_SOCK=~/.1password/agent.sock
            fi
          '')
      ]);

      shellAliases = {
        hm-switch = "home-manager switch --flake $HOME/workspace/dotfiles -b backup";
        rebuild = "sudo nixos-rebuild switch --flake $HOME/workspace/dotfiles --impure";
        rollback = "sudo nixos-rebuild switch --rollback";
        k = "${pkgs.kubectl-1-25}/bin/kubectl ";

        # git
        gco = "git checkout \$(git branch | fzf)";
        g = "git";
        gpr = "git pull --rebase";
        gpp = "git pull --rebase && git push";
        gs = "git status";
        gst = "git status";
        gap = "git add -p";
        root = "cd \$(git root || pwd)";

        ":q" = "exit";
        ":Q" = "exit";
        ":qa" = "exit";

        # vim
        v = "vim ";
        temp = "vim \$(mktemp)";
        vtemp = "vim \$(mktemp)";
        vimdiff = "vim -d ";

        # useful when piping output to vim
        vyaml = "nvim -c 'set filetype=yaml' -";
        vjson = "nvim -c 'set filetype=json' -";

        #Grafana
        logcli = "nix run --no-write-lock-file --impure path:/home/twhitney/workspace/dotfiles#logcli -- ";
        loki = "nix run --no-write-lock-file --impure path:/home/twhitney/workspace/dotfiles#loki -- ";
        promtail = "nix run --no-write-lock-file --impure path:/home/twhitney/workspace/dotfiles#promtail -- ";
        gcom = "nix run --impure path:/home/twhitney/workspace/dotfiles#gcom -- ";
        gcom-dev = "nix run --impure path:/home/twhitney/workspace/dotfiles#gcom-dev -- ";
        gcom-ops = "nix run --impure path:/home/twhitney/workspace/dotfiles#gcom-dev -- ";
        flux-ignore = "nix run --impure path:/home/twhitney/workspace/dotfiles#flux-ignore -- -actor=trevor.whitney@grafana.com ";
        rt = "nix run --impure path:/home/twhitney/workspace/dotfiles#rt -- ";
      };
    };
  };
}

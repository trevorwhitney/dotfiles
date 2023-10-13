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
            # Solarized
            export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#586e75,bg=#002b36"
          else
            export BAT_THEME="Solarized (light)"
            export FZF_PREVIEW_PREVIEW_BAT_THEME="Solarized (light)"
            # Solarized
            export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#93a1a1,bg=#fdf6e3"
            # Seoulbones
            # export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#93a1a1,bg=#e2e2e2"
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

          # completions
          complete -o nospace -C "${pkgs.gocomplete}/bin/gocomplete" go
          complete -o nospace -C "${pkgs.nomad}/bin/nomad" nomad

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
        rebuild = "sudo nixos-rebuild switch --flake $HOME/workspace/dotfiles";
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

        # useful when piping output to vim
        vyaml = "nvim -c 'set filetype=yaml' -";
        vjson = "nvim -c 'set filetype=json' -";

        # needed because of KDE unlock weirdness
        unlock =
          let
            activateAndUnlock = pkgs.writeShellScriptBin "activate-and-unlock" ''
              function unlock() {
                local session=$1
                ${pkgs.systemd}/bin/loginctl unlock-session $session
                ${pkgs.systemd}/bin/loginctl activate $session
              }

              unlock $@
            '';
          in
          "${activateAndUnlock}/bin/activate-and-unlock";

        #Grafana
        logcli = "nix run --no-write-lock-file github:trevorwhitney/dotfiles\\?dir=nix/flakes/loki#logcli -- ";
        loki = "nix run github:trevorwhitney/dotfiles\\?dir=nix/flakes/loki#loki -- ";
        promtail = "nix run github:trevorwhitney/dotfiles\\?dir=nix/flakes/loki#promtail -- ";
        gcom = "nix run github:trevorwhitney/dotfiles\\?dir=nix/flakes/deployment_tools#gcom -- ";
        gcom-dev = "nix run github:trevorwhitney/dotfiles\\?dir=nix/flakes/deployment_tools#gcom-dev -- ";
        gcom-ops = "nix run github:trevorwhitney/dotfiles\\?dir=nix/flakes/deployment_tools#gcom-ops -- ";
        flux-ignore = "nix run github:trevorwhitney/dotfiles\\?dir=nix/flakes/deployment_tools#flux-ignore -- -actor=trevor.whitney@grafana.com ";
        rt = "nix run github:trevorwhitney/dotfiles\\?dir=nix/flakes/deployment_tools#rt -- ";
      };
    };
  };
}

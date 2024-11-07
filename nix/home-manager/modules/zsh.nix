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
      useBrew = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "whether to add /opt/homebrew/bin to PATH";
      };
      useDotNetTools = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "whether to add $HOME/.dotnet/tools to PATH";
      };
      # this is normally done in /etc/zshrc, but since osx nukes that on every update
      # we may need to do it ourselves
      startNixDaemon = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "whether to source the nix daemon startup script for darwin";
      };
    };
  };

  config = {
    programs.zsh = {
      enable = true;
      autocd = false;
      defaultKeymap = "viins";
      enableCompletion = false;

      autosuggestion = {
        enable = true;
      };

      oh-my-zsh = {
        enable = true;
        theme = "twhitney";
        plugins = [ "ruby" "vi-mode" "mvn" "aws" "docker" "docker-compose" ];
        custom = "${custom}";
      };

      sessionVariables = {
        HYPHEN_INSENSITIVE = "true";
        KEYTIMEOUT = "17";
        WORDCHARS = "*?_-.[]~=&;!#$%^(){}<>";
        ZSH_AUTOSUGGEST_STRATEGY = [ "history" "completion" ];
      };

      history = {
        path = "$HOME/.zsh_history";
        save = 10000000;
        size = 10000000;
      };

      # TODO: do we still need this AND home.sessionVariables?
      envExtra = ''
        export EDITOR="nvim";
        export OPENAI_API_KEY="$(${pkgs.coreutils}/bin/cat ${config.age.secrets.openApiKey.path})";
        export ANTHROPIC_API_KEY="$(${pkgs.coreutils}/bin/cat ${config.age.secrets.anthropicApiKey.path})";
        export XDG_CACHE_HOME="${config.home.homeDirectory}/.cache";
        export XDG_CONFIG_HOME="${config.home.homeDirectory}/.config";
        export XDG_DATA_HOME="${config.home.homeDirectory}/.local/share";
        export XDG_STATE_HOME="${config.home.homeDirectory}/.local/state";
      '';

      initExtraFirst = builtins.concatStringsSep "\n" [
        (lib.optionalString cfg.useBrew
          ''
            eval "$(/opt/homebrew/bin/brew shellenv)"
          '')
        (lib.optionalString cfg.useDotNetTools
          ''
            PATH="$PATH:$HOME/.dotnet/tools"
          '')
        ''
          PATH="$HOME/.local/bin''${PATH+:''$PATH}"
        ''
        (lib.optionalString cfg.startNixDaemon
          ''
            if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
              . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
            fi
          '')
      ];

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

          autoload -Uz compinit
          compinit -i

          source <(${pkgs.kubectl}/bin/kubectl completion zsh)
          complete -F __start_kubectl k

          autoload -U +X bashcompinit && bashcompinit

          if [ -n "$TMUX" ]; then
            bat_theme="$(tmux show-environment -g | grep "^BAT_THEME")"
            preview_bat_theme="$(tmux show-environment -g | grep "^FZF_PREVIEW_PREVIEW_BAT_THEME")"
            autosuggest_highlight_style="$(tmux show-environment -g | grep "^ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE")"

            if [ -n "''${bat_theme}" ]; then
              eval "export \"''${bat_theme}\""
            else
              eval "export BAT_THEME=\"Solarized (light)\""
            fi

            if [ -n "''${preview_bat_theme}" ]; then
              eval "export \"''${preview_bat_theme}\""
            else
              eval "export FZF_PREVIEW_PREVIEW_BAT_THEME=\"Solarized (light)\""
            fi

            if [ -n "''${autosuggest_highlight_style}" ]; then
              eval "export \"''${autosuggest_highlight_style}\""
            else
              eval "export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=\"fg=#a6b0a0,bg=#f3ead3\""
            fi
          fi
        ''
        (lib.optionalString cfg.use1Password
          ''
            if [ -z "$SSH_TTY" ]; then
              eval "export SSH_AUTH_SOCK=~/.1password/agent.sock"
            fi
          '')
      ]);

      shellAliases = {
        dots = "cd $HOME/workspace/dotfiles";
        hm-switch = "${pkgs.home-manager}/bin/home-manager switch --flake $HOME/workspace/dotfiles -b backup ";
        rollback = "sudo nixos-rebuild switch --rollback";
        k = "${pkgs.kubectl}/bin/kubectl ";

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
      };
    };
  };
}

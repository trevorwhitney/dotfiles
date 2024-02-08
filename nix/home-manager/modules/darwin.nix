{ config, pkgs, lib, ... }:
let inherit (pkgs) dotfiles;
  change-background = with pkgs; writeShellScriptBin "change-background" ''
      function change_background() {
        local mode="light"

        if [[ ''${DARKMODE:-0} -eq 1 ]]; then
          mode="dark"
        fi

        echo "changing background to ''${mode}"

        for pid in ''$(pgrep vim); do kill -SIGUSR1 "''${pid}"; done

        ${tmux}/bin/tmux set-environment -g BACKGROUND "''${mode}"
        ${tmux}/bin/tmux source-file ~/.config/tmux/tmux.conf

        # change kitty
        case "''${mode}" in
        dark)
          ${kitty}/bin/kitten themes --reload-in=all "Everforest Dark Soft"
          ${tmux}/bin/tmux set-environment -g BAT_THEME "Solarized (dark)"
          ${tmux}/bin/tmux set-environment -g FZF_PREVIEW_PREVIEW_BAT_THEME "Solarized (dark)"

          ${tmux}/bin/tmux set-environment -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE "fg=#d3c6aa,bg=#333c43"
          ;;
        *)
          ${kitty}/bin/kitten themes --reload-in=all "Everforest Light Soft"
          ${tmux}/bin/tmux set-environment -g BAT_THEME "Solarized (light)"
          ${tmux}/bin/tmux set-environment -g FZF_PREVIEW_PREVIEW_BAT_THEME "Solarized (light)"

          ${tmux}/bin/tmux set-environment -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE "fg=#5c6a72,bg=#f3ead3"
          ;;
        esac
      }

      change_background
  '';
in
{
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    java = {
      enable = true;
      package = pkgs.jdk11;
    };

    direnv = {
      enable = true;
      nix-direnv = { enable = true; };
    };

    zsh.shellAliases = {
      brew = "/opt/homebrew/bin/brew ";
    };
  };

  home = {
    file = {
      ".ctags".source = "${dotfiles}/ctags";
      ".dircolors".source = "${dotfiles}/dircolors";
      ".git-authors".source = "${dotfiles}/git-authors";
      ".prettierrc".source = "${dotfiles}/prettierrc.json";
      ".markdownlint.json".source = "${dotfiles}/markdownlint.json";
      ".todo/config".source = "${dotfiles}/todo.cfg";
      ".ideavimrc".source = "${dotfiles}/ideavimrc";
      ".gnupg/gpg.conf".text = ''
        default-key  78F930867F302694

        keyserver  hkp://pool.sks-keyservers.net
        use-agent
      '';
      "Library/LaunchAgents/ke.bou.dark-mode-notify.plist".text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>ke.bou.dark-mode-notify</string>
            <key>KeepAlive</key>
            <true/>
            <key>StandardErrorPath</key>
            <string>/var/log/dark-mode-notify-stderr.log</string>
            <key>StandardOutPath</key>
            <string>/var/log/dark-mode-notify-stdout.log</string>
            <key>ProgramArguments</key>
            <array>
               <string>/usr/local/bin/dark-mode-notify</string>
               <string>${change-background}/bin/change-background</string>
            </array>
        </dict>
        </plist>
      '';
    };

    packages = with pkgs; [
      awscli2
      azure-cli
      bat
      bind
      cmake
      coreutils
      curl
      delta
      diffutils
      fd
      fzf
      gnused
      gnumake
      go
      (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        beta
        alpha
        gke-gcloud-auth-plugin
      ]))
      jq
      lsof
      lua51Packages.luarocks
      luajit
      mosh
      ncurses
      ngrok
      nmap
      rbenv
      ripgrep
      virtualenv
      yarn
      yq
    ];
  };

  # Currently broken: https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = false;
}

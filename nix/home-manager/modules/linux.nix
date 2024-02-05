{ config, pkgs, lib, ... }:
let inherit (pkgs) dotfiles;
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
    };

    tmux.extraConfig = ''
      # -- run new sessions with systemd to benefit from systemd oomd --
      set -g default-command 'systemd-run --user --scope zsh'
    '';
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

      ".mozilla/native-messaging-hosts/tridactyl.json".source =
        "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

      ".tridactylrc".source = "${dotfiles}/config/tridactyl/tridactylrc";
    };

    packages = with pkgs; [
      gocomplete
      jsonnet
      jsonnet-lint
      protoc-gen-gogofast
      protoc-gen-gogoslick
      kns-ktx
      xk6

      awscli2
      azure-cli
      bashInteractive
      bat
      bind
      chart-testing
      cmake
      curl
      delta
      diffutils
      docker
      docker-compose
      drone-cli
      fd
      file
      fzf
      glow
      gnused
      gnumake
      go
      (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        beta
        alpha
        gke-gcloud-auth-plugin
      ]))
      gradle
      helm-docs
      jsonnet-bundler
      jq
      kotlin
      kube3d
      kubernetes-helm
      lsof
      lua51Packages.luarocks
      luajit
      lynis
      mktemp
      mosh
      ncurses
      ngrok
      nmap
      pex
      rbenv
      ripgrep
      tanka
      terraform
      tmate
      todo-txt-cli
      tridactyl-native
      tz
      vagrant
      vault
      virtualenv
      yamale
      yarn
      yq

      # rust-bin.stable.latest.default # to bring in rustc, but not sure if it's needed in common
    ];
  };

  # Currently broken: https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = false;
}

{ config, pkgs, lib, ... }:
let dotfiles = (pkgs.callPackage ./pkgs/dotfiles { });
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "twhitney";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # /usr/share/pop:/home/twhitney/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/:/var/lib/snapd/desktop
  targets.genericLinux.enable = true;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  home.sessionVariables = { EDITOR = "vim"; };

  home.file.".ctags".source = "${dotfiles}/ctags";
  home.file.".dircolors".source = "${dotfiles}/dircolors";
  home.file.".git-authors".source = "${dotfiles}/git-authors";
  xdg.configFile."k9s/gruvbox-light-skin.yml".source =
    "${dotfiles}/config/gruvbox-light-skin.yml";
  xdg.dataFile."applications/defaults.list".source =
    "${dotfiles}/share/applications/defaults.list";
  xdg.dataFile."applications/gnvim.desktop".source =
    "${dotfiles}/share/applications/gnvim.desktop";

  # these are packages I need on the command line as well
  # TODO: move lua-language-server to neovim extra package
  # and refactor config to take base sumneko path
  # TODO: install stylua via luarocks
  # TODO: copy google cloud sdk completion
  # ln -sf /usr/share/google-cloud-sdk/completion.zsh.inc "$HOME/.oh-my-zsh/custom/gcloud-completion.zsh"
  # ~/.nix-profile/google-cloud-sdk/completion.zsh.inc 
  # TODO: mkdir $HOME/go?
  # TODO: add lua?

  home.packages = with pkgs; [
    (pkgs.callPackage ./pkgs/goimports { })
    (pkgs.callPackage ./pkgs/gocomplete { })
    (pkgs.callPackage ./pkgs/jsonnet { })
    (pkgs.callPackage ./pkgs/jsonnet-lint { })
    (pkgs.callPackage ./pkgs/jsonnetfmt { })
    (pkgs.callPackage ./pkgs/protoc-gen-gogofast { })
    (pkgs.callPackage ./pkgs/protoc-gen-gogoslick { })
    (pkgs.callPackage ./pkgs/kns-ktx { })

    azure-cli
    bash
    bat
    cargo
    curl
    delta
    drone-cli
    fzf
    gh
    gnused
    go_1_17
    golangci-lint
    google-cloud-sdk
    helm-docs
    jsonnet-bundler
    kotlin
    kube3d
    kubectl
    kubernetes-helm
    lm_sensors
    lua51Packages.luarocks
    luajit
    nodejs
    ncurses
    rbenv
    ruby
    rustc
    sysstat
    tanka
    terraform
    vault
    xsel
    yarn
  ];

  #TODO: lua53packages.luarocks
  #TODO: add luarocks and stylua

  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };

  # enabling bash makes sure ~/.profile is setup correctly
  # which some other things rely on
  programs.bash = { enable = true; };

  programs.direnv = { enable = true; };

  imports = [
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/zsh.nix
  ];
}

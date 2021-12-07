{ config, pkgs, lib, ... }: {
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

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  # these are packages I need on the command line as well
  # TODO: move lua-language-server to neovim extra package
  # and refactor config to take base sumneko path
  # TODO: install stylua via luarocks
  # TODO: copy google cloud sdk completion
  # ln -sf /usr/share/google-cloud-sdk/completion.zsh.inc "$HOME/.oh-my-zsh/custom/gcloud-completion.zsh"
  # ~/.nix-profile/google-cloud-sdk/completion.zsh.inc 
  # TODO: mkdir $HOME/go?

  home.packages = with pkgs; [
    azure-cli
    bash
    bat
    drone-cli
    fzf
    gh
    go_1_17
    golangci-lint
    google-cloud-sdk
    gnused
    jsonnet-bundler
    kube3d
    kubectl
    lm_sensors
    # TODO: refactor to get stylua binary in
    # neovim module
    lua53Packages.luarocks
    ncurses
    rbenv
    ruby
    # todo should be able to remove this once config
    # is refactored to take path
    sumneko-lua-language-server
    sysstat
    tanka
    vault
    xsel
    yarn
  ];

  #TODO: lua53packages.luarocks
  #TODO: add luarocks and stylua

  programs.direnv = {
    enable = true;
  };

  imports = [ ./modules/neovim.nix ./modules/tmux.nix ./modules/zsh.nix ];
}

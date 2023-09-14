{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/1password.nix
    ../modules/bash.nix
    ../modules/common.nix
    ../modules/firefox.nix
    ../modules/git.nix
    ../modules/k9s.nix
    ../modules/kde.nix
    ../modules/kitty.nix
    ../modules/kubernetes.nix
    ../modules/neovim.nix
    ../modules/spotify.nix
    ../modules/tmux.nix
    ../modules/xdg.nix
    ../modules/zsh.nix
  ];

  # Currently broken: https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = false;

  programs.firefox = {
    profiles.default.settings = {
      "media.ffmpeg.vaapi.enabled" = true;
      "media.ffvpx.enabled" = false;
      "gfx.webrender.all" = true;
      "layout.css.overflow-overlay.enabled" = true;
    };
  };

  programs.git = {
    gpgPath = "${pkgs.gnupg}/bin/gpg";
    includes =
      [{ path = "${pkgs.secrets}/git"; }];
  };

  programs.neovim = {
    withLspSupport = true;
  };

  programs.gh = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

  programs.kubectl = {
    enable = true;
    package = pkgs.kubectl-1-25;
  };
}

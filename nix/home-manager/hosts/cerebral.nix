{ config, pkgs, lib, ... }: {
  imports = [
    ../../home-manager/modules/bash.nix
    ../../home-manager/modules/common.nix
    ../../home-manager/modules/firefox.nix
    ../../home-manager/modules/git.nix
    /* ../../home-manager/modules/gnome.nix */
    ../../home-manager/modules/kde.nix
    ../../home-manager/modules/kitty.nix
    ../../home-manager/modules/neovim.nix
    ../../home-manager/modules/spotify.nix
    ../../home-manager/modules/tmux.nix
    ../../home-manager/modules/xdg.nix
    ../../home-manager/modules/zsh.nix
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

  programs.alacritty = {
    enable = true;
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
}

{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    _1password-gui
    alacritty
    firefox
    gimp
    google-chrome
    insomnia
    kitty
    slack
    spotify
    vlc
  ];
}

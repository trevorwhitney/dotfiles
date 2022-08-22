{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    _1password-gui
    alacritty
    firefox
    insomnia
    kitty
    slack
    spotify
  ];
}

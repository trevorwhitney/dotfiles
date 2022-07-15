{ config, pkgs, lib, ... }:
let inherit (pkgs) dotfiles secrets;
in
{
  xdg.configFile."i3".source = "${dotfiles}/config/i3";
  home.file.".local/share/backgrounds/solarized-bubbles.png".source =
    "${dotfiles}/wallpaper/solarized-bubbles.png";
  home.file.".local/share/backgrounds/family.jpg".source =
    "${secrets}/backgrounds/family.jpg";

  home.packages = with pkgs; [ rofi ];
}

{ config, pkgs, lib, ... }: 
let inherit (pkgs) dotfiles;
in
{
  xdg.configFile."i3".source = "${dotfiles}/config/i3";
  home.file.".local/share/backgrounds/solarized-bubbles.pngs".source = "${dotfiles}/wallpapers/solarized-bubbles.png";
}

{ config, pkgs, lib, ... }:
let inherit (pkgs) dotfiles;
in
{
  home.file.".local/share/fonts".source = "${dotfiles}/polybar-fonts";
  xdg.configFile."polybar".source = "${dotfiles}/config/polybar";
}

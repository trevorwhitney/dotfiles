{ config, pkgs, lib, ... }:
let inherit (pkgs) dotfiles;
in
{
  xdg.configFile."polybar".source = "${dotfiles}/polybar";
  xdg.homeFile.".local/share/fonts".source = "${dotfiles}/polybar-fonts";
}

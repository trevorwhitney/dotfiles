{ config, pkgs, lib, ... }: 
let inherit (pkgs) dotfiles;
in
{
  xdg.configFile."i3".source = "${dotfiles}/config/i3";
  xdg.configFile."polybar".source = "${dotfiles}/config/polybar";
}

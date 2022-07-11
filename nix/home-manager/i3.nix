{ config, pkgs, lib, ... }: 
let inherit (pkgs) dotfiles;
in
{
  xdg.configFile."i3".source = "${dotfiles}/config/i3";
}

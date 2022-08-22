{ config, pkgs, lib, ... }:
let
  inherit (pkgs) dotfiles;
  cfg = config.programs.alacritty;
in
{
  options = { };

  config = { xdg.configFile."kitty".source = "${dotfiles}/config/kitty"; };
}

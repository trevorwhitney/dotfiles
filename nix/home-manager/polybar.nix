{ config, pkgs, lib, ... }:
let inherit (pkgs) dotfiles;
in
{
  home.file.".local/share/fonts/fantasque_sans_mono.ttf".source =
    "${dotfiles}/polybar-fonts/fantasque_sans_mono.ttf";
  home.file.".local/share/fonts/feather.ttf".source =
    "${dotfiles}/polybar-fonts/feather.ttf";
  home.file.".local/share/fonts/iosevka_nerd_font.ttf".source =
    "${dotfiles}/polybar-fonts/iosevka_nerd_font.ttf";
  home.file.".local/share/fonts/material_design_iconic_font.ttf".source =
    "${dotfiles}/polybar-fonts/material_design_iconic_font.ttf";
  home.file.".local/share/fonts/panels".source =
    "${dotfiles}/polybar-fonts/panels";
  home.file.".local/share/fonts/terminus".source =
    "${dotfiles}/polybar-fonts/terminus";
  home.file.".local/share/fonts/waffle.bdf".source =
    "${dotfiles}/polybar-fonts/waffle.bdf";

  xdg.configFile."polybar".source = "${dotfiles}/config/polybar";

  home.packages = with pkgs; [ polybarFull playerctl ];
}

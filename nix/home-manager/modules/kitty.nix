{ config, pkgs, lib, ... }:
let
  inherit (pkgs) dotfiles;
  cfg = config.programs.kitty;
in
{
  options = { };

  config = {
    programs.kitty = {
      enable = true;
      settings = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 14;
        scrollback_pager = ''nvim -c "set nonumber nolist showtabline=0 foldcolumn=0" -c "autocmd TermOpen * normal G" -c "map q :qa!<CR>" -c "silent write! /tmp/kitty_scrollback_buffer | te head -c-1 /tmp/kitty_scrollback_buffer; rm /tmp/kitty_scrollback_buffer; cat"'';
        copy_on_select = "yes";

        #TODO: these don't seem to do anything
        hide_window_decorations = "yes";
        window_border_width = "3px";
        draw_minimal_borders = "yes";
        active_border_color = "#268bd2";
        inactive_border_color = "#eee8d5";
        window_margin_width = 1;
      };

      keybindings = {
        "kitty_mod+k" = "clear_terminal to_cursor active";
      };

      theme = "seoulbones_light";
    };
  };
}

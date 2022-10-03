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
        font_size = 12;
        scrollback_pager = ''nvim -c "set nonumber nolist showtabline=0 foldcolumn=0" -c "autocmd TermOpen * normal G" -c "map q :qa!<CR>" -c "silent write! /tmp/kitty_scrollback_buffer | te head -c-1 /tmp/kitty_scrollback_buffer; rm /tmp/kitty_scrollback_buffer; cat"'';
        copy_on_select = "clipboard";

        ## Begin solarized light theme
        foreground = "#657b83";
        background = "#fdf6e3";
        selection_foreground = "#586e75";
        selection_background = "#eee8d5";

        # Cursor colors
        cursor = "#657b83";
        cursor_text_color = "#fdf6e3";

        # kitty window border colors
        active_border_color = "#cb4b16";
        inactive_border_color = "#93a1a1";

        # Tab bar colors
        active_tab_background = "#fdf6e3";
        active_tab_foreground = "#657b83";
        inactive_tab_background = "#93a1a1";
        inactive_tab_foreground = "#fdf6e3";

        # The basic 16 colors

        # black
        color0 = "#073642";
        color8 = "#93a1a1";
        # red

        color1 = "#dc322f";
        color9 = "#cb4b16";
        # green

        color2 = "#859900";
        color10 = "#586e75";
        # yellow

        color3 = "#b58900";
        color11 = "#657b83";
        # blue

        color4 = "#268bd2";
        color12 = "#839496";
        # magenta

        color5 = "#d33682";
        color13 = "#6c71c4";

        # cyan
        color6 = "#2aa198";
        color14 = "#93a1a1";

        # white
        color7 = "#eee8d5";
        color15 = "#fdf6e3";

        ## End solarized light theme

      };

      keybindings = {
        "kitty_mod+k" = "clear_terminal to_cursor active";
      };
    };
  };
}

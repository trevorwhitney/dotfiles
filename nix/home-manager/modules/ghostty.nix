{ pkgs, lib, ... }:
let
  settings = {
    cursor-style = "block";
    cursor-style-blink = false;
    font-family = "JetBrainsMono Nerd Font Mono";
    font-size = 14;
    link-url = true;
    shell-integration = "zsh";
    shell-integration-features = "no-cursor";
    theme = "dark:Atom,light:Light Owl";
    macos-titlebar-style = "tabs";
  };
  keybindings = ''

    # Vim-style split navigation
    # Uses Cmd+Ctrl to avoid the "Hide Others" (Cmd+Opt+H) system conflict
    keybind = cmd+opt+h=goto_split:left
    keybind = cmd+opt+j=goto_split:bottom
    keybind = cmd+opt+k=goto_split:top
    keybind = cmd+opt+l=goto_split:right

    # Optional: Vim-style split resizing
    # Uses Cmd+Ctrl+Shift
    keybind = cmd+opt+shift+h=resize_split:left,10
    keybind = cmd+opt+shift+j=resize_split:down,10
    keybind = cmd+opt+shift+k=resize_split:up,10
    keybind = cmd+opt+shift+l=resize_split:right,10
  '';
  themes = {
    # USing the soft versions of:
    # https://github.com/metalelf0/everforest.ghostty
    everforest-dark = {
      palette = [
        "0=#4b565c"
        "1=#e67e80"
        "2=#a7c080"
        "3=#dbbc7f"
        "4=#7fbbb3"
        "5=#d699b6"
        "6=#83c092"
        "7=#d3c6aa"
        "8=#4b565c"
        "9=#e67e80"
        "10=#a7c080"
        "11=#dbbc7f"
        "12=#7fbbb3"
        "13=#d699b6"
        "14=#83c092"
        "15=#d3c6aa"
      ];
      background = "#333c43";
      foreground = "#d3c6aa";
      cursor-color = "#d3c6aa";
      selection-foreground = "#323d43";
      selection-background = "#d3c6aa";
    };
    everforest-light = {
      palette = [
        "0=#5c6a72"
        "1=#f85552"
        "2=#8da101"
        "3=#dfa000"
        "4=#3a94c5"
        "5=#df69ba"
        "6=#35a77c"
        "7=#dfddc8"
        "8=#5c6a72"
        "9=#f85552"
        "10=#8da101"
        "11=#dfa000"
        "12=#3a94c5"
        "13=#df69ba"
        "14=#35a77c"
        "15=#dfddc8"
      ];
      background = "#f3ead3";
      foreground = "#5c6a72";
      cursor-color = "#5c6a72";
      selection-foreground = "#f8f0dc";
      selection-background = "#5c6a72";
    };
  };
  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;
in
{
  xdg.configFile = lib.mkMerge [
    {
      "ghostty/config" = lib.mkIf (settings != { }) {
        text = (keyValue.generate "ghostty-config" settings).text + keybindings;
      };
    }

    (lib.mkIf (themes != { }) (
      lib.mapAttrs' (name: value: {
        name = "ghostty/themes/${name}";
        value = {
          source = keyValue.generate "ghostty-${name}-theme" value;
        };
      }) themes
    ))
  ];
}

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
    # theme = "dark:Atom,light:Light Owl";
    # theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
    theme = "dark:Kanagawa Wave,light:Kanagawa Lotus";
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

    # passthrough for Cmd+P
    keybind = unconsumed:cmd+p=text:
  '';
  themes = import ./themes.nix;
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
      lib.mapAttrs'
        (name: value: {
          name = "ghostty/themes/${name}";
          value = {
            source = keyValue.generate "ghostty-${name}-theme" value;
          };
        })
        themes
    ))
  ];
}

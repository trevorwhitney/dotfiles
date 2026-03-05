{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/workspace/dotfiles/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    "zed/settings.json".source = mkSymlink "${dotfilesPath}/misc/zed/settings.json";
    "zed/keymap.json".source = mkSymlink "${dotfilesPath}/misc/zed/keymap.json";
    "zed/debug.json".source = mkSymlink "${dotfilesPath}/misc/zed/debug.json";
    "zed/tasks.json".source = mkSymlink "${dotfilesPath}/misc/zed/tasks.json";
  };
}

{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/workspace/dotfiles/dotfiles";
  configHome = config.xdg.configHome;
in
{
  imports = [ ./live-links.nix ];

  dotfiles.liveLinks = {
    "${configHome}/zed/settings.json" = "${dotfilesPath}/misc/zed/settings.json";
    "${configHome}/zed/keymap.json" = "${dotfilesPath}/misc/zed/keymap.json";
    "${configHome}/zed/debug.json" = "${dotfilesPath}/misc/zed/debug.json";
    "${configHome}/zed/tasks.json" = "${dotfilesPath}/misc/zed/tasks.json";
  };
}

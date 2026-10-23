{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/workspace/dotfiles/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".claude/settings.json".source = mkSymlink "${dotfilesPath}/claude/settings.json";
    ".claude/CLAUDE.md".source = mkSymlink "${dotfilesPath}/claude/CLAUDE.md";
  };
}

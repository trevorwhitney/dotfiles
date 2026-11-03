{ config, ... }:
let
  homeDir = config.home.homeDirectory;
  dotfilesPath = "${homeDir}/workspace/dotfiles/dotfiles";
in
{
  imports = [ ./live-links.nix ];

  dotfiles.liveLinks = {
    "${homeDir}/.claude/settings.json" = "${dotfilesPath}/claude/settings.json";
    "${homeDir}/.claude/CLAUDE.md" = "${dotfilesPath}/claude/CLAUDE.md";
  };
}

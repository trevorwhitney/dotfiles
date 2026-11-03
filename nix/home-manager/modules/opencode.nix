{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/workspace/dotfiles/dotfiles";
  configHome = config.xdg.configHome;
in
{
  imports = [ ./live-links.nix ];

  home.sessionVariables = {
    OPENCODE_EXPERIMENTAL_MARKDOWN = "false";
    OPENCODE_DISABLE_PROJECT_CONFIG = "true";
  };

  dotfiles.liveLinks = {
    "${configHome}/opencode/opencode.json" = "${dotfilesPath}/opencode/opencode.json";
    "${configHome}/opencode/plugins/superset-notify-instance-reset.js" =
      "${dotfilesPath}/opencode/plugins/superset-notify-instance-reset.js";
  };
}

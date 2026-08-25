{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/workspace/dotfiles/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.sessionVariables = {
    OPENCODE_EXPERIMENTAL_MARKDOWN = "false";
    OPENCODE_DISABLE_PROJECT_CONFIG = "true";
  };

  xdg.configFile = {
    "opencode/opencode.json".source = mkSymlink "${dotfilesPath}/opencode/opencode.json";
  };
}

{ config, ... }:
{
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    min-release-age=7
    fund=false
  '';
}

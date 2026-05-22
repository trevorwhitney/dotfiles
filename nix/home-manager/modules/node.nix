{ config, ... }:
{
  # npm (also read by pnpm)
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    min-release-age=7
    fund=false
    engine-strict=true
    ignore-scripts=true
  '';

  home.file.".yarnrc.yml".text = ''
    npmMinimalAgeGate: 10080
    enableScripts: false
  '';

  # pnpm global config. pnpm also reads ~/.npmrc, but it has its own
  # keys (e.g. minimum-release-age vs npm's min-release-age) so we
  # manage them here too.
  xdg.configFile."pnpm/rc".text = ''
    minimum-release-age=10080
    ignore-scripts=true
  '';
}

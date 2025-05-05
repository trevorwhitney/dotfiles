{ loki }:
{ config, pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.callPackage ../packages/deployment-tools {
      inherit (pkgs) stdenv lib;
      inherit (loki.packages.${pkgs.system}) logcli;
      deploymentToolsSecretsPath = config.age.secrets."deploymentTools.sh".path;
    })
  ];
}

{ config, pkgs, lib, ... }:
let
  cfg = config.programs.kubectl;
in
{
  options = {
    programs.kubectl = {
      enable = lib.mkEnableOption "kubectl";
      package = lib.mkPackageOption pkgs "kubectl" { };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
      kns-ktx
      kubernetes-helm
    ];
  };
}

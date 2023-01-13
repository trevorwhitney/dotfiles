{ config, lib, pkgs, ... }:
with lib;

{

  options = {
    environment.binbash = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        Include a /bin/bash in the system.
      '';
    };
  };

  config = {

    system.activationScripts.binbash =
      if config.environment.binbash != null
      then ''
        mkdir -m 0755 -p /bin
        ln -sfn ${config.environment.binbash} /bin/bash
      ''
      else ''
        rm -f /bin/bash
      '';

  };
}

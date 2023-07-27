{ pkgs, lib, config, ... }:
{
  systemd.services."launcher.kolide-k2" = {
    description = "The Kolide Launcher";
    after = [ "network.service" "syslog.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      #Environment = with pkgs; builtins.trace kolide kolide.env;
      ExecStart = with pkgs; writers.writeBash "kolide-launcher" ''
        ${kolide}/bin/launcher -config ${kolide}/etc/launcher.flags
      '';
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}

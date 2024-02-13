{ pkgs, lib, config, ... }:
{
  systemd.timers."dynamic-dns-reporter" = {
    description = "Timer for dynamic dns reporter";
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "5m";
      Persistent = "true";
    };
    wantedBy = [ "timers.target" ];
  };

  systemd.services."dynamic-dns-reporter" = {
    description = "Dynamic DNS reporter for dnsimple";
    wants = [ "dynamic-dns-reporter.timer" "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = with pkgs; writers.writeBash "dynamic-dns-reporter" ''
        source ${secrets}/dnsimple/credentials.sh
        ${dynamic-dns-reporter}/bin/dynamic-dns-reporter $DNSIMPLE_ACCOUNT_ID $DNSIMPLE_API_KEY plex
      '';
      Type = "oneshot";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}

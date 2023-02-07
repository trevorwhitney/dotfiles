{ pkgs, lib, config, ... }:
let
  backupPath = name:
    let
      path = "/var/lib/${name}";
    in
    {
      wantedBy = [ "default.target" ];
      description = "Check if path ${path} has changed";
      pathConfig = {
        PathChanged = path;
        Unit = "backup.service";
      };
    };
in
{
  systemd.paths = lib.genAttrs [ "nzbget" "sonarr" "radarr" "plex" "tailscale" ] backupPath;

  systemd.services."backup" = {
    description = "Back up files";
    serviceConfig = {
      ExecStart = with pkgs; writers.writeBash "backup" ''
        ${rsync}/bin/rsync -a --delete \
          /var/lib/nzbget \
          /var/lib/plex \
          /var/lib/radarr \
          /var/lib/sonarr \
          /var/lib/tailscale \
          /mnt/wd/backups/monterey
      '';
    };
  };
}

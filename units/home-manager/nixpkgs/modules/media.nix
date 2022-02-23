{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [ prowlarr radarr sonarr jellyfin ];

  systemd.user.services.radarr = {
    Unit = {
      Description = "Radarr Daemon";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";

      # Change the path to Radarr or mono here if it is in a different location for you.
      ExecStart = "${pkgs.radarr}/bin/Radarr -nobrowser";
      TimeoutStopSec = 20;
      KillMode = "process";
      Restart = "on-failure";

      # These lines optionally isolate (sandbox) Radarr from the rest of the system.
      # Make sure to add any paths it might use to the list below (space-separated).
      #ReadWritePaths=/opt/Radarr /path/to/movies/folder
      #ProtectSystem=strict
      #PrivateDevices=true
      #ProtectHome=true
    };

    Install = { WantedBy = [ "default.target" ]; };
  };

  systemd.user.services.sonarr = {
    Unit = {
      Description = "Sonarr Daemon";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";

      # Change the path to Radarr or mono here if it is in a different location for you.
      ExecStart = "${pkgs.sonarr}/bin/NzbDrone -nobrowser";
      TimeoutStopSec = 20;
      KillMode = "process";
      Restart = "on-failure";

      # These lines optionally isolate (sandbox) Radarr from the rest of the system.
      # Make sure to add any paths it might use to the list below (space-separated).
      #ReadWritePaths=/opt/Radarr /path/to/movies/folder
      #ProtectSystem=strict
      #PrivateDevices=true
      #ProtectHome=true
    };

    Install = { WantedBy = [ "default.target" ]; };
  };

  systemd.user.services.prowlarr = {
    Unit = {
      Description = "Prowlarr Daemon";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";

      # Change the path to Radarr or mono here if it is in a different location for you.
      ExecStart = "${pkgs.prowlarr}/bin/Prowlarr -nobrowser";
      TimeoutStopSec = 20;
      KillMode = "process";
      Restart = "on-failure";

      # These lines optionally isolate (sandbox) Radarr from the rest of the system.
      # Make sure to add any paths it might use to the list below (space-separated).
      #ReadWritePaths=/opt/Radarr /path/to/movies/folder
      #ProtectSystem=strict
      #PrivateDevices=true
      #ProtectHome=true
    };

    Install = { WantedBy = [ "default.target" ]; };
  };

  systemd.user.services.jellyfin = {
    Unit = {
      Description = "Jellyfin Media Server";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";

      # Change the path to Radarr or mono here if it is in a different location for you.
      ExecStart = "${pkgs.jellyfin}/bin/jellyfin";
      TimeoutSec = 15;
      KillMode = "process";
      Restart = "on-failure";
    };

    Install = { WantedBy = [ "default.target" ]; };
  };
}

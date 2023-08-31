{ pkgs, ... }: {
  home.packages = with pkgs; [ spotify-tui spotifyd ];

  systemd.user.services.spotifyd = {
    Unit = {
      Description = "A spotify playing daemon";
      Documentation = "https://github.com/Spotifyd/spotifyd";
      Wants = [ "sound.target" "network-online.target" ];
      After = [ "sound.target" "network-online.target" ];
    };

    Service = {
      Type = "simple";

      ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon";
      Restart = "always";
      RestartSec = 12;
    };

    Install = { WantedBy = [ "default.target" ]; };
  };
}

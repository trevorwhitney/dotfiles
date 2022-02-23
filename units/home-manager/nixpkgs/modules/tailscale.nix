{ config, pkgs, lib, ... }:
let socket = "\${HOME}/.local/run/tailscale/tailscaled.sock";
in
{
  home.packages = with pkgs; [ tailscale ];

  systemd.user.services.tailscaled = with pkgs; {
    Unit = {
      Description = "Tailscale node agent";
      Documentation = "https://tailscale.com/kb/";
      Wants = "network-pre.target";
      After =
        "network-pre.target NetworkManager.service systemd-resolved.service";
    };

    Service = {
      ExecStartPre = "${tailscale}/bin/tailscaled --cleanup";
      ExecStart =
        "${tailscale}/bin/tailscaled --state=\${HOME}/.local/var/lib/tailscale/tailscaled.state --socket=${socket} --port=41641 --tun=userspace-networking";
      ExecStopPost = "${tailscale}/bin/tailscaled --cleanup";

      Restart = "on-failure";

      RuntimeDirectory = "tailscale";
      RuntimeDirectoryMode = 755;
      StateDirectory = "tailscale";
      StateDirectoryMode = 700;
      CacheDirectory = "tailscale";
      CacheDirectoryMode = 750;
      Type = "notify";
    };

    Install = { WantedBy = [ "default.target" ]; };
  };

  programs.zsh.shellAliases = with pkgs; {
    tailscale = "${tailscale}/bin/tailscale --socket=${socket} ";
  };
}

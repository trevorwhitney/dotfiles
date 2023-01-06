{ pkgs, lib, config, ... }: {
  imports = [
    ../../modules/networking/openvpn.nix
    ../../modules/services/monterey-backup.nix
  ];

  services = {
    plex = {
      enable = true;
      openFirewall = true;
    };

    sonarr = {
      enable = true;
      openFirewall = true;
      group = "plex";
    };
    radarr = {
      enable = true;
      openFirewall = true;
      group = "plex";
    };

    nzbget = {
      enable = true;
      group = "plex";
    };
  };

  systemd.services =
    let
      joinVpnNamespace = {
        bindsTo = [ "vpn-namespace.service" ];
        after = [ "vpn-namespace.service" ];
        unitConfig.JoinsNamespaceOf = "netns@openvpn.service";
        serviceConfig.PrivateNetwork = true;
      };
    in
    {
      sonarr = joinVpnNamespace;
      radarr = joinVpnNamespace;
      nzbget = joinVpnNamespace;
    };

  environment.systemPackages = with pkgs; [
    bind
  ];
}

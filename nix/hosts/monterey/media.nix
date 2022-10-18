{ pkgs, lib, config, ... }: {
  imports = [
    /* ../../nixos/networking/wireguard.nix */
    /* ../../nixos/networking/openvpn.nix */
    /* ../../nixos/services/nzbget.nix */
    #TODO: ../../nixos/services/privoxy.nix
  ];

  services = {
    plex = {
      enable = true;
      openFirewall = true;
    };
    sonarr = {
      enable = true;
      openFirewall = true;
    };
    radarr = {
      enable = true;
      openFirewall = true;
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gnumake
    kube3d
    kind
  ];
}

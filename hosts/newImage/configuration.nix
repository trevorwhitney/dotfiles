{
  newImage = { modulesPath, lib, pkgs, name, ... }:
    let tailscaleInf = "tailscale0";
    in
    {
      imports =
        lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix
        ++ [ (modulesPath + "/virtualisation/digital-ocean-config.nix") ];

      deployment.targetHost = "164.92.115.209";
      deployment.targetUser = "root";

      networking.hostName = name;

      # Prepare system for flakes
      nix.package = pkgs.nixFlakes;
      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';

      nixpkgs.config.allowUnfree = true;

      users.users.twhitney = {
        isNormalUser = true;
        home = "/home/twhitney";
        extraGroups = [ "wheel" "docker" ];
        openssh.authorizedKeys.keys = [
          # cerebral
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSeuF+NMj8sKD8kWuahlSasaPzHzT5Jhip+Y+EAcfEv trevorjwhitney@gmail.com"
          # crostini
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINX1x10BU/7kbO24ZtX7Lz6IHd55KiWt0cMdlxlTHjlp trevorjwhitney@gmail.com"
        ];
        shell = pkgs.zsh;
      };

      environment.systemPackages = with pkgs; [
        docker
        git
        gnumake
        k9s
        kind
        kube3d
        kubectl
        libcxx
        slack
        vim
        wget
      ];

      # Enable tailscale
      services.tailscale.enable = true;
      services.tailscale.interfaceName = tailscaleInf;
      networking.firewall.checkReversePath = "loose";
      networking.firewall.trustedInterfaces = [ tailscaleInf ];

      # Open ports in the firewall.
      networking.firewall.enable = true;
      # Docker will open these up anyway...
      # Maybe I want ufw on top of iptables?
      # networking.firewall.allowedTCPPorts =
      # [ 7878 8989 9696 6789 30004 30005 30008 30009 ];
      # networking.firewall.allowedUDPPorts = [ ... ];

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "22.05"; # Did you read the comment?

      # enable docker
      virtualisation.docker.enable = true;

      # enable gpg
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
}

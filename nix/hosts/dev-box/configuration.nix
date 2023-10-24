{ pkgs, lib, config, ... }: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";


  # Prepare system for flakes
  nix =
    {
      package = pkgs.nixVersions.stable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      settings = {
        trusted-users = [
          "@wheel"
          "vagrant"
        ];
        trusted-public-keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf trevorjwhitney@gmail.com"
        ];
      };
    };

  networking = {
    hostName = "dev-box"; # Define your hostname.
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw



  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/vagrant" =
    {
      device = "vagrant";
      fsType = "vboxsf";
    };

  fileSystems."/home/vagrant/workspace" =
    {
      device = "home_vagrant_workspace";
      fsType = "vboxsf";
    };

  virtualisation.virtualbox.guest.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.fsIdentifier = "provided";
  boot.loader.grub.device = "/dev/sda";
}

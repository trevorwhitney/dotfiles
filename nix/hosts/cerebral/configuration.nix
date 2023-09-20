# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  tailscaleInf = "tailscale0";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 32;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_6_1;
  boot.supportedFilesystems = [ "ntfs" ];

  # Prepare system for flakes
  nix =
    {
      package = pkgs.nixVersions.stable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

  # Enable networking
  networking.hostName = "cerebral"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Needed to prevent wait online from causing rebuild to fail
  # See https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # nix-alien allows running of programs with hardcoded link loaders
    # requires nix-ld, which is enabled below
    # see: https://github.com/thiagokokada/nix-alien
    nix-alien

    curl
    dropbox
    git
    google-drive-ocamlfuse
    home-manager
    usbutils
    vim
    wget
  ];

  environment.binbash = "${pkgs.bashInteractive}/bin/bash";

  programs = {
    gnupg.agent = {
      # enable = true;
      enable = false;
    };

    dconf.enable = true;

    # Needed to run deal with hardcoded link loaders
    # in some downloaded binaries
    # See:
    nix-ld = {
      enable = true;
    };

    zsh = {
      enable = true;
      ohMyZsh.enable = true;
      enableCompletion = false;
    };
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  # Enable firewall
  networking = {
    firewall = {
      enable = true;
      # for tailscale
      checkReversePath = "loose";
      trustedInterfaces = [ tailscaleInf ];

      #TODO: can I limit this to specific interfaces?
      allowedTCPPorts = [
        80
        443
        8080
        3100
        8631

        3389 # RDP

        32400 # plex
      ];

      allowedUDPPorts = [
        3389 # RDP
      ];
    };
  };

  # enable docker
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let tailscaleInf = "tailscale0";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Prepare system for flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  networking.hostName = "stem"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable gnome
  services.xserver.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };
  services.xserver.desktopManager.gnome.enable = true;

  # Pretty boot screen
  boot.plymouth.enable = false;

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:ctrl";

  services.resolved.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.twhitney = {
    isNormalUser = true;
    home = "/home/twhitney";
    extraGroups = [ "wheel" "networkmanager" "docker" "plex" ];
    openssh.authorizedKeys.keys = [
      # cerebral
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSeuF+NMj8sKD8kWuahlSasaPzHzT5Jhip+Y+EAcfEv trevorjwhitney@gmail.com"
      # crostini
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINX1x10BU/7kbO24ZtX7Lz6IHd55KiWt0cMdlxlTHjlp trevorjwhitney@gmail.com"
    ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    cryptsetup
    docker
    firefox
    git
    gnome3.gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.pop-shell
    gnumake
    home-manager
    k9s
    kind
    kube3d
    kubectl
    libcxx
    nerdfonts
    vim
    wget
  ];

  environment.gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
    ++ (with pkgs.gnome; [
    atomix # puzzle game
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gnome-music
    hitori # sudoku game
    iagno # go game
    tali # poker game
    totem # video player
  ]);

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable plex
  # allow unfree software (needed for plex)
  nixpkgs.config.allowUnfree = true;

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # Enable tailscale
  services.tailscale.enable = true;
  services.tailscale.interfaceName = tailscaleInf;
  networking.firewall.checkReversePath = "loose";
  networking.firewall.trustedInterfaces = [ tailscaleInf ];

  # Open ports in the firewall.
  networking.firewall.enable = true;
  # Docker will open these up anyway...
  # Maybe I want ufw on top of iptables?
  networking.firewall.allowedTCPPorts = [ 7878 8989 9696 6789 30004 30005 30008 30009 ];
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
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let tailscaleInf = "tailscale0";
in
{
  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  # Prepare system for flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  networking.hostName = "virtualbox"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Denver";

  services.xserver = {
    enable = true;
    libinput.mouse.naturalScrolling = true;
  };

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  programs.dconf.enable = true;

  # Pretty boot screen
  #boot.plymouth.enable = false;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:ctrl";

  services.resolved.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    _1password
    _1password-gui
    alacritty
    firefox
    git
    gnumake
    home-manager
    libcxx
    lxappearance
    slack
    spotify
    vim
    wget

    #TODO: move to dotfiles flake
    polybarFull
    playerctl
    psmisc
    rofi
  ];

  fonts.fonts = with pkgs;
    [
      (nerdfonts.override {
        fonts = [
          "DroidSansMono"
          "FantasqueSansMono"
          "Iosevka"
          "JetBrainsMono"
          "Noto"
          "Terminus"
          "VictorMono"
        ];
      })
    ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable plex
  # allow unfree software (needed for plex)
  nixpkgs.config.allowUnfree = true;

  # Enable tailscale
  services.tailscale.enable = true;
  services.tailscale.interfaceName = tailscaleInf;
  networking.firewall.checkReversePath = "loose";
  networking.firewall.trustedInterfaces = [ tailscaleInf ];

  # Open ports in the firewall.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # enable gpg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}

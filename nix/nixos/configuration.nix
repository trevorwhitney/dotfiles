# This is a base configuration, meant to work for all
# my nix systems, and is the starting point during a new
# nix install;
{ config, pkgs, ... }: {

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # Prepare system for flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;

  # enable networking via network manager
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # enable resolved for DNS resolution
  services.resolved.enable = true;

  # Define my user account. Don't forget to set a password with ‘passwd’.
  users.users.twhitney = {
    isNormalUser = true;
    home = "/home/twhitney";
    # TODO: this probably needs to be configurable, maybe just don't include it here?
    extraGroups = [ "wheel" "networkmanager" "docker" "plex" ];
    openssh.authorizedKeys.keys = [
      # cerebral
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSeuF+NMj8sKD8kWuahlSasaPzHzT5Jhip+Y+EAcfEv trevorjwhitney@gmail.com"
      # crostini
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINX1x10BU/7kbO24ZtX7Lz6IHd55KiWt0cMdlxlTHjlp trevorjwhitney@gmail.com"
    ];
    shell = pkgs.zsh;
    uid = 1000;
  };
  
  # Allow my user to do rebuilds
  nix.settings.trusted-users = [ "twhitney" ];

  # List of basic packages to install on a new system
  # to allow a nix-rebuild switch --flake once booted.
  environment.systemPackages = with pkgs; [
    curl
    git
    gnumake
    home-manager
    vim
    wget
  ];

  # Enable the OpenSSH daemon.
  # useful for finishing installation remotely
  services.openssh.enable = true;

  # enable gpg, needed for signing git commits
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Configure keymap in X11
  # map caps -> ctrl
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:ctrl";

  # Enable flatpak
  services.flatpak.enable = true;
}

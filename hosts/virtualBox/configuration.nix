# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  tailscaleInf = "tailscale0";
  seagate_crypt = "seagate_crypt";
  wd_crypt = "wd_crypt";
in
{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # Prepare system for flakes
  nix =
    {
      package = pkgs.nixFlakes;
      settings.trusted-users = [ "twhitney" ];
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

  # allow unfree software (needed for plex)
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "monterey"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  services = {
    xserver = {
      enable = true;
      libinput.mouse.naturalScrolling = true;

      # Configure keymap in X11
      layout = "us";
      xkbOptions = "ctrl:nocaps";

      displayManager = {
        autoLogin = {
          enable = true;
          user = "twhitney";
        };
      };
    };
    resolved.enable = true;
    openssh.enable = true;
    tailscale = {
      enable = true;
      interfaceName = tailscaleInf;
    };
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

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    # for tailscale
    checkReversePath = "loose";
    trustedInterfaces = [ tailscaleInf ];
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    dconf.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.twhitney = {
    isNormalUser = true;
    description = "Trevor's user account";
    home = "/home/twhitney";
    extraGroups = [ "wheel" "networkmanager" "vboxsf" "docker" "plex" ];
    openssh.authorizedKeys.keys = [
      # cerebral
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSeuF+NMj8sKD8kWuahlSasaPzHzT5Jhip+Y+EAcfEv trevorjwhitney@gmail.com"
      # crostini
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINX1x10BU/7kbO24ZtX7Lz6IHd55KiWt0cMdlxlTHjlp trevorjwhitney@gmail.com"
    ];
    shell = pkgs.zsh;
    hashedPassword = "$6$mzDIaYphEyrcer5G$bwtMRRlI.sy3nfn.F108p5xwiVc9bEdSfVhfmrKY8wtBrUrJi5kvPSUQfNXr7aHpkyDy1qURkT2ffxVVJuyjn1";
    uid = 1000;
  };

  environment.etc.crypttab =
    {
      enable = true;
      text =
        let
          seagateKey =
            let
              seagateSecretPath = config.age.secrets.seagate_secret_key.path;
            in
            pkgs.runCommand "copy_seagate_key"
              {
                src = ./secrets;
              } ''
              mkdir -p $out
              cp $src/seagate_secret_key $out/seagate_secret_key
            '';

          wdKey =
            let
              wdSecretPath = config.age.secrets.wd_secret_key.path;
            in
            pkgs.runCommand "copy_wd_key"
              {
                src = ./secrets;
              } ''
              mkdir -p $out
              cp $src/wd_secret_key $out/wd_secret_key
            '';
        in
        ''
          ${seagate_crypt} UUID=3466bf26-59db-471f-85f9-610fd8807c1a ${seagateKey}/seagate_secret_key luks,nofail
          ${wd_crypt} UUID=a0ac0856-8d02-4c96-bc6d-4d990e6ef67f ${wdKey}/wd_secret_key luks,nofail
        '';
    };

  fileSystems."/mnt/seagate" = {
    device = "/dev/mapper/${seagate_crypt}";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/wd" = {
    device = "/dev/mapper/${wd_crypt}";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  # enable docker
  virtualisation.docker.enable = true;
}

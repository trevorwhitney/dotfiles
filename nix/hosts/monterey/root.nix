{ pkgs, lib, config, ... }:
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
  system.stateVersion = "22.11"; # Did you read the comment?


  # Prepare system for flakes
  nix =
    {
      package = pkgs.nixVersions.stable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

  networking = {
    hostName = "monterey"; # Define your hostname.
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # NetworkManager-wait-online.service fails to restart on nixos-rebuild
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Denver";

  services = {
    xserver = {
      enable = true;
      libinput.mouse.naturalScrolling = true;

      # Configure keymap in X11
      layout = "us";
      xkbOptions = "ctrl:nocaps";
      # Add some more video drivers to give X11 a shot at working in
      # VMware and QEMU.
      videoDrivers =
        lib.mkOverride 40 [ "virtualbox" "vmware" "cirrus" "vesa" "modesetting" ];
    };

    resolved.enable = true;
    openssh.enable = true;
    tailscale = {
      enable = true;
      interfaceName = tailscaleInf;
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

  environment.etc.crypttab =
    {
      enable = true;
      text =
        ''
          ${seagate_crypt} UUID=3466bf26-59db-471f-85f9-610fd8807c1a ${pkgs.secrets}/seagate_secret_key luks,nofail
          ${wd_crypt} UUID=a0ac0856-8d02-4c96-bc6d-4d990e6ef67f ${pkgs.secrets}/wd_secret_key luks,nofail
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

  security.sudo = {
    wheelNeedsPassword = false;
    execWheelOnly = true;
  };
}

{ config, pkgs, lib, ... }:
(with lib; {
  imports = [
    <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    <nixpkgs/nixos/modules/profiles/clone-config.nix>
  ];

  # FIXME: UUID detection is currently broken
  boot.loader.grub.fsIdentifier = "provided";

  # requires a device to be created on the virutal machine named dotfiles
  # fileSystems."/mnt/dotfiles" = {
  # fsType = "vboxsf";
  # device = "dotfiles";
  # options = [ "rw" ];
  # };

  # Add some more video drivers to give X11 a shot at working in
  # VMware and QEMU.
  services.xserver.videoDrivers =
    mkOverride 40 [ "virtualbox" "vmware" "cirrus" "vesa" "modesetting" ];

  powerManagement.enable = false;
  system.stateVersion = mkDefault "22.05";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.twhitney = {
    isNormalUser = true;
    description = "Trevor's user account";
    home = "/home/twhitney";
    extraGroups = [ "wheel" "networkmanager" "vboxsf" ];
    openssh.authorizedKeys.keys = [
      # cerebral
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSeuF+NMj8sKD8kWuahlSasaPzHzT5Jhip+Y+EAcfEv trevorjwhitney@gmail.com"
      # crostini
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINX1x10BU/7kbO24ZtX7Lz6IHd55KiWt0cMdlxlTHjlp trevorjwhitney@gmail.com"
    ];
    shell = pkgs.zsh;
    password = "stones";
    uid = 1000;
  };

  nix.settings.trusted-users = [ "twhitney" ];

  services.xserver = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "twhitny";
      };

      sddm = { enable = mkForce false; };
      gdm = { enable = true; };
    };
    desktopManager = { plasma5.enable = mkForce false; };
  };
})

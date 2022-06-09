# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
let
  seagate_crypt = "seagate_crypt";
  wd_crypt = "wd_crypt";
in
{
  imports = [
    (modulesPath + "/hardware/network/broadcom-43xx.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6883de9d-4e75-46df-ae4b-132655badce9";
    fsType = "ext4";
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/e6118f1f-f28b-4a5d-bf2a-e0788426c244";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/nix/store" = {
    device = "/data/nix/store";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home" = {
    device = "/data/home";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4455-E47D";
    fsType = "vfat";
  };

  environment.etc.crypttab = {
    enable = true;
    text = ''
      ${seagate_crypt} UUID=3466bf26-59db-471f-85f9-610fd8807c1a /etc/luks-keys/seagate_secret_key luks
      ${wd_crypt} UUID=a0ac0856-8d02-4c96-bc6d-4d990e6ef67f /etc/luks-keys/wd_secret_key luks
    '';
  };

  fileSystems."/mnt/seagate" = {
    device = "/dev/mapper/${seagate_crypt}";
    fsType = "ext4";
  };

  fileSystems."/mnt/wd" = {
    device = "/dev/mapper/${wd_crypt}";
    fsType = "ext4";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/19e4f435-3a75-497f-9e5b-eba1409850dd"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}

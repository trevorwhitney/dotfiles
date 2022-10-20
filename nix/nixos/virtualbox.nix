{ pkgs, config, ... }: {
  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  # FIXME: UUID detection is currently broken
  boot.loader.grub.fsIdentifier = "provided";

  powerManagement.enable = false;

  services.openssh.enable = true;
}

{ self, secrets, pkgs, lib, modulesPath, home-manager, nurPkgs, nixos-hardware, ... }:
let
  # Keep virtualbox on 6.x
  # since not all my images work on 7.x
  cerebralPkgs = pkgs.extend (import "${self}/nix/overlays/virtualbox.nix");
in
[
  {
    nixpkgs =
      {
        pkgs = cerebralPkgs;
        hostPlatform = "x86_64-linux";
      };
  }

  nixos-hardware.nixosModules.system76
  nixos-hardware.nixosModules.common-cpu-amd
  nixos-hardware.nixosModules.common-gpu-amd

  "${self}/nix/modules/1password.nix"
  "${self}/nix/modules/gc.nix"

  ./audio.nix
  ./auto-upgrade.nix
  ./configuration.nix
  ./services.nix
  ./graphics.nix
  ./twhitney.nix
  ./virtualbox.nix
  ./webcam.nix

  ../../modules/desktops/kde.nix
  ../../modules/fonts.nix
  ../../modules/gui-apps.nix
  ../../modules/binbash.nix

  ../../services/dynamic-dns-reporter.nix

  home-manager.nixosModules.home-manager
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "bak";
    home-manager.users.twhitney = {
      programs.firefox.nurPkgs = nurPkgs;
      # Do not need to change this when updating home-manager versions.
      # Only change when release notes indicate it's required, as it
      # usually requires some manual intervention.
      home.stateVersion = "22.11";

      imports = [ ../../home-manager/hosts/cerebral.nix ];
    };
  }
]

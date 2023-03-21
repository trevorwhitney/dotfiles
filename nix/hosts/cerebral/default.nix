{ self, secrets, pkgs, lib, modulesPath, home-manager, nurPkgs, nixos-hardware, ... }: [
  {
    nixpkgs =
      {
        inherit pkgs;
        hostPlatform = "x86_64-linux";
      };
  }

  nixos-hardware.nixosModules.system76
  nixos-hardware.nixosModules.common-cpu-amd
  nixos-hardware.nixosModules.common-gpu-amd

  ./configuration.nix
  ./twhitney.nix
  ./graphics.nix

  ../../modules/desktops/gnome-shell.nix
  ../../modules/gui-apps.nix
  ../../modules/binbash.nix

  home-manager.nixosModules.home-manager
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.twhitney = {
      programs.firefox.nurPkgs = nurPkgs;
      home.stateVersion = "22.05";
      imports = [ ../../home-manager/hosts/cerebral.nix ];
    };
  }
]

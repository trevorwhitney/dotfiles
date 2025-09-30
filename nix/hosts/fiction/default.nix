{ self, pkgs, home-manager, agenix, loki, nix-darwin, determinate, ... }:
nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  modules = [
    agenix.nixosModules.default
    home-manager.darwinModules.home-manager
    determinate.darwinModules.default

    (import ./system.nix { inherit self pkgs; })
    (import ./home-manager.nix { inherit pkgs agenix; })

    ./determinate.nix
    ./homebrew.nix
    ./remote-build.nix
    ./secrets.nix
    ./twhitney.nix

    ../../modules/desktops/macos.nix
    (import ../../modules/deployment-tools.nix { inherit loki; })
  ];
}


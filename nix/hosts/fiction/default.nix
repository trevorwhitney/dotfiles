{ self, pkgs, home-manager, agenix, loki, nix-darwin, ... }:
nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  modules = [
    agenix.nixosModules.default
    home-manager.darwinModules.home-manager
    (import ./system.nix { inherit self pkgs; })
    (import ./home-manager.nix { inherit pkgs agenix; })

    ./homebrew.nix
    ./remote-build.nix
    ./secrets.nix
    ./twhitney.nix

    ../../modules/desktops/macos.nix
    (import ../../modules/deployment-tools.nix { inherit loki; })
  ];
}


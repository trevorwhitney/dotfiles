{ self, secrets, pkgs, lib, modulesPath, flake-utils, home-manager, ... }:
{
  nixosConfigurations = import ./hosts { inherit self secrets pkgs lib modulesPath home-manager; };
  common = import ./nixos { inherit pkgs lib; };
} // flake-utils.lib.eachDefaultSystem (system: {
  homeConfigurations = import ./home-manager { inherit pkgs home-manager system; };
})

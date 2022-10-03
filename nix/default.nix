{ self, pkgs, flake-utils, home-manager, ... }:
{
  nixosConfigurations = import ./hosts;
} // flake-utils.lib.eachDefaultSystem (system: {
  homeConfigurations = import ./home-manager { inherit pkgs home-manager system; };
})

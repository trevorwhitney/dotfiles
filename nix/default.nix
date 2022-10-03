{ self, pkgs, flake-utils, home-manager, ... }:
{
  overlay = final: prev: rec { };
  hosts = import ./hosts;
} // flake-utils.lib.eachDefaultSystem (system: {
  homes = import ./home-manager { inherit pkgs home-manager system; };
})

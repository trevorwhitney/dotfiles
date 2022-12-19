{ self, secrets, pkgs, lib, modulesPath, home-manager, nur, nixos-hardware, ... }:
let
  nurPkgs = import nur {
    inherit pkgs;
    nurpkgs = pkgs;
  };
in
{
  monterey = lib.nixosSystem {
    system = "x86_64-linux";
    modules = import ./monterey {
      inherit self secrets pkgs lib modulesPath home-manager nurPkgs nixos-hardware;
    };
  };
  cerebral = lib.nixosSystem {
    system = "x86_64-linux";
    modules = import ./cerebral {
      inherit self secrets pkgs lib modulesPath home-manager nurPkgs nixos-hardware;
    };
  };
}

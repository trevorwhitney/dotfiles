{ self, secrets, pkgs, lib, modulesPath, home-manager, nur, nixos-hardware, ... }:
let
  nurPkgs = import nur {
    inherit pkgs;
    nurpkgs = pkgs;
  };
in
{
  cerebral = lib.nixosSystem {
    system = "x86_64-linux";
    modules = import ./cerebral {
      inherit self secrets pkgs lib modulesPath home-manager nurPkgs nixos-hardware;
    };
  };
  dev-box = lib.nixosSystem {
    system = "x86_64-linux";
    modules = import ./dev-box {
      inherit self pkgs home-manager modulesPath;
    };
  };
}

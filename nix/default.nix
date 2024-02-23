{ agenix
, flake-utils
, home-manager
, lib
, modulesPath
, nixos-hardware
, nur
, packages
, secrets
, self
, systems
, ...
}:
{
  nixosConfigurations = import ./hosts {
    inherit self secrets lib modulesPath home-manager nur nixos-hardware;
    pkgs = packages.x86_64-linux;
  };
  common = import ./nixos {
    inherit lib;
    pkgs = packages.x86_64-linux;
  };
} // flake-utils.lib.eachSystem systems (system: {
  homeConfigurations = import ./home-manager {
    inherit agenix home-manager system nur;

    pkgs = packages.${system};
  };
})

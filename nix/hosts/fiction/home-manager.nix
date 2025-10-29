{ pkgs, agenix, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";

    users.twhitney = {
      # Pass our custom pkgs to home-manager modules
      _module.args.pkgs = pkgs;

      # Do not need to change this when updating home-manager versions.
      # Only change when release notes indicate it's required, as it
      # usually requires some manual intervention.
      home.stateVersion = "24.05";

      imports = [
        agenix.homeManagerModules.default
        {
          home.packages = [
            agenix.packages.aarch64-darwin.default
          ];
        }

        ../../home-manager/hosts/fiction.nix
      ];
    };
  };
}


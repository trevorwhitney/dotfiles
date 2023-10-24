{ self, pkgs, home-manager, ... }: [
  {
    nixpkgs = {
      inherit pkgs;
      hostPlatform = "x86_64-linux";
    };

    # virtualbox = {
    #   baseImageSize = 50 * 1024;
    #   memorySize = 4096;
    # };

    environment.systemPackages = with pkgs; [
      curl
      git
      home-manager
      man
      vim
      wget
      (pkgs.writeShellScriptBin "bootstrap-dev-box" ''
        /run/current-system/activate
        PATH="${pkgs.git}/bin:$PATH" nixos-rebuild switch --flake /home/vagrant/workspace/dotfiles/
      '')
    ];
  }

  "${self}/nix/modules/virtualbox.nix"
  "${self}/nix/modules/gc.nix"
  "${self}/nix/modules/gui-apps.nix"
  "${self}/nix/modules/binbash.nix"
  ./configuration.nix
  ./vagrant.nix

  home-manager.nixosModules.home-manager
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "bak";
    home-manager.users.vagrant = {
      # Do not need to change this when updating home-manager versions.
      # Only change when release notes indicate it's required, as it
      # usually requires some manual intervention.
      home.stateVersion = "23.05";

      imports = [ "${self}/nix/home-manager/hosts/dev-box.nix" ];
    };
  }
]

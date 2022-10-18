{ self, secrets, pkgs, lib, modulesPath, home-manager, ... }: {
  /* stem = import ./stem.nix { inherit self secrets pkgs lib home-manager; }; */
  /* stem = lib.nixosSystem { */
  /*   modules = [ */
  /*     { nixpkgs.pkgs = pkgs; } */
  /*     "${self}/hosts/stem/configuration.nix" */
  /*     "${self}/nix/nixos/desktops/gnome-i3.nix" */
  /*     home-manager.nixosModules.home-manager */
  /*     ./stem.nix */
  /*   ]; */
  /* }; */

  monterey = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {
        nixpkgs =
          {
            inherit pkgs;
            hostPlatform = "x86_64-linux";
          };
        /* services.xserver = { */
        /*   desktopManager.xterm.enable = true; */
        /* }; */
      }
      "${modulesPath}/virtualisation/virtualbox-image.nix"
      ../nixos/virtualbox.nix
      ./monterey/root.nix
      ./monterey/twhitney.nix
      ./monterey/media.nix
      ../nixos/desktops/gnome-shell.nix
      home-manager.nixosModules.home-manager
      {

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.twhitney = {
          imports = [
            /* ../home-manager/modules/gnome.nix */
            ../home-manager/modules/kitty.nix
            ../home-manager/modules/common.nix
            ../home-manager/modules/bash.nix
            ../home-manager/modules/git.nix
            ../home-manager/modules/neovim.nix
            ../home-manager/modules/tmux.nix
            /* ../home-manager/modules/xdg.nix */
            ../home-manager/modules/zsh.nix
          ];

          programs.git = {
            gpgPath = "/usr/bin/gpg";
            includes =
              [{ path = "${pkgs.secrets}/git"; }];
          };
          /* programs.firefox = { */
          /*   enable = true; */
          /* }; */
          programs.neovim = {
            withLspSupport = false;
          };
        };
      }
    ];
  };
}

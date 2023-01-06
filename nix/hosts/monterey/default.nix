{ self, secrets, pkgs, lib, modulesPath, home-manager, nurPkgs, nixos-hardware, ... }: [
  {
    nixpkgs =
      {
        inherit pkgs;
        hostPlatform = "x86_64-linux";
      };
  }
  "${modulesPath}/virtualisation/virtualbox-image.nix"
  ../../modules/virtualbox.nix
  ./root.nix
  ./twhitney.nix
  ./media.nix
  ../../modules/desktops/gnome-shell.nix
  ../../modules/networking/rdp.nix
  home-manager.nixosModules.home-manager
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.twhitney = {
      imports = [
        ../../home-manager/modules/kitty.nix
        ../../home-manager/modules/common.nix
        ../../home-manager/modules/bash.nix
        ../../home-manager/modules/git.nix
        ../../home-manager/modules/neovim.nix
        ../../home-manager/modules/tmux.nix
        ../../home-manager/modules/zsh.nix
      ];

      # Currently broken: https://github.com/NixOS/nixpkgs/issues/196651
      manual.manpages.enable = false;

      programs.firefox = {
        enable = true;
      };

      programs.git = {
        gpgPath = "/usr/bin/gpg";
        includes =
          [{ path = "${pkgs.secrets}/git"; }];
      };
      programs.neovim = {
        withLspSupport = false;
      };
    };
  }
]

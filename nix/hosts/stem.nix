{ pkgs, ... }:
pkgs.lib.nixosSystem {
  inherit system;

  modules = [
    { nixpkgs.pkgs = pkgs; }
    "${self}/hosts/stem/configuration.nix"
    "${self}/nix/nixos/desktops/gnome-i3.nix"
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.twhitney = {
        imports = [
          ./nix/home-manager/alacritty.nix
          ./nix/home-manager/common.nix
          ./nix/home-manager/bash.nix
          ./nix/home-manager/git.nix
          { programs.git.gpgPath = with pkgs; "${gnupg}/bin/gpg"; }
          ./nix/home-manager/i3.nix
          ./nix/home-manager/polybar.nix
          ./nix/home-manager/tmux.nix
          ./nix/home-manager/zsh.nix
          ./nix/home-manager/neovim.nix
          { programs.neovim = { withLspSupport = true; }; }
        ];

        programs.git.includes =
          [{ path = "${secrets.defaultPackage.${system}}/git"; }];

        programs.zsh.sessionVariables = {
          LD_LIBRARY_PATH =
            "${pkgs.unstable.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
        };

        home.file.".local/share/backgrounds/family.jpg".source =
          "${pkgs.secrets}/backgrounds/family.jpg";
      };
    }
  ];
}

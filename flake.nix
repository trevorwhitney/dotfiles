{
  description = "Stem NixOS System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=ea38cf5ecec5b6a0eebb8bbe1416bcff4bea55aa";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    dotfiles.url = "./nix/flakes/dotfiles";
    dotfiles.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    dotfiles.inputs.flake-utils.follows = "flake-utils";

    i3-gnome-flashback.url = "./nix/flakes/i3-gnome-flashback";
    i3-gnome-flashback.inputs.nixpkgs.follows = "nixpkgs";
    i3-gnome-flashback.inputs.flake-utils.follows = "flake-utils";

    # For running OpenGL apps outside of NixOS
    nixgl.url = "github:guibou/nixGL";

    # Firefox nightly
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
  };

  outputs =
    { self
    , dotfiles
    , nixpkgs-mozilla
    , flake-utils
    , home-manager
    , i3-gnome-flashback
    , neovim-nightly-overlay
    , nixgl
    , nixpkgs
    , nixpkgs-unstable
    , secrets
    , ...
    }:
    let
      system = "x86_64-linux";
      unstable = nixpkgs-unstable.legacyPackages."${system}";
      overlays = [
        neovim-nightly-overlay.overlay
        dotfiles.overlay
        secrets.overlay
        i3-gnome-flashback.overlay
        (final: prev: {
          inherit unstable;
          #Packages to override from unstable
          inherit (unstable) gopls gotools jsonnet i3-gaps nerdfonts nodePackages siji;
        })
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config = { allowUnfree = true; };
      };

      secretsPkg = secrets.defaultPackage."${system}";
    in
    {
      nixosConfigurations = {
        stem = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            { nixpkgs.pkgs = pkgs; }
            "${self}/hosts/stem/configuration.nix"
            "${self}/nix/nixos/desktops/gnome.nix"
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
        };

        virtualbox = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            { nixpkgs.pkgs = pkgs; }
            "${self}/hosts/virtualBox/base.nix"
            "${self}/hosts/virtualBox/configuration.nix"
            "${self}/nix/nixos/desktops/gnome.nix"
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
                  { programs.git.gpgPath = "/usr/bin/gpg"; }
                  ./nix/home-manager/neovim.nix
                  ./nix/home-manager/tmux.nix
                  ./nix/home-manager/zsh.nix
                  ./nix/home-manager/i3.nix
                  ./nix/home-manager/polybar.nix
                  ./nix/home-manager/gnome.nix
                  {
                    programs.neovim = {
                      withLspSupport = false;
                      package = pkgs.neovim-nightly;
                    };
                    polybar = {
                      hostConfig = ./hosts/virtualBox/host.ini;
                      includeSecondary = false;
                    };
                    i3.hostConfig = ./hosts/virtualBox/host.conf;
                  }
                ];

                programs.git.includes =
                  [{ path = "${secrets.defaultPackage.${system}}/git"; }];

                programs.zsh.sessionVariables = {
                  LD_LIBRARY_PATH =
                    "${pkgs.unstable.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
                };
              };
            }
          ];
        };
      };

      homeConfigurations =
        let
          username = "twhitney";
          homeDirectory = "/home/${username}";
          baseConfig = { inherit username homeDirectory; };

          sharedConfig = {
            programs.git.includes =
              [{ path = "${secrets.defaultPackage.${system}}/git"; }];
          };

          sharedImports = [
            ./nix/home-manager/common.nix
            ./nix/home-manager/bash.nix
            ./nix/home-manager/git.nix
            { programs.git.gpgPath = "/usr/bin/gpg"; }
            ./nix/home-manager/neovim.nix
            ./nix/home-manager/tmux.nix
            ./nix/home-manager/xdg.nix
            ./nix/home-manager/zsh.nix
          ];

        in
        {
          "twhitney@cerebral" =
            let
              pkgs = import nixpkgs {
                inherit system;
                overlays = overlays ++ [
                  nixgl.overlay
                  nixpkgs-mozilla.overlays.firefox
                  (import ./nix/hosts/cerebral.nix).overlay
                ];
                config = { allowUnfree = true; };
              };
            in
            home-manager.lib.homeManagerConfiguration
              (baseConfig // {
                inherit pkgs;
                system = "x86_64-linux";

                configuration = sharedConfig // {
                  imports = [
                    ./nix/home-manager/gnome.nix
                    ./nix/home-manager/i3.nix
                    ./nix/home-manager/polybar.nix
                    ./nix/home-manager/spotify.nix
                    ./nix/home-manager/alacritty.nix
                    ./nix/home-manager/kitty.nix
                    {
                      home.packages = with pkgs; [
                        _1password-gui
                        alacritty
                        kitty
                        # firefox requires --impure flag because of how it pulls binaries
                        firefox
                        flatpak
                        slack
                        spotify
                        google-chrome
                      ];
                      programs.firefox = {
                        enable = true;
                        package = pkgs.firefox;
                      };
                      programs.kitty = {
                        package = pkgs.kitty;
                      };
                      programs.alacritty = {
                        package = pkgs.alacritty;
                      };
                      programs.neovim = {
                        withLspSupport = true;
                        package = pkgs.neovim-nightly;
                      };
                      polybar = {
                        hostConfig = ./hosts/cerebral/host.ini;
                        includeSecondary = true;
                      };
                      i3.hostConfig = ./hosts/cerebral/host.conf;
                    }
                  ] ++ sharedImports;
                };
              });

          "twhitney@virtualbox" = home-manager.lib.homeManagerConfiguration
            (baseConfig // {
              inherit pkgs;
              system = "x86_64-linux";

              configuration = sharedConfig // {
                imports = [
                  ./nix/home-manager/i3.nix
                  ./nix/home-manager/polybar.nix
                  ./nix/home-manager/gnome.nix
                  {
                    programs.neovim = {
                      withLspSupport = false;
                      package = pkgs.neovim-nightly;
                    };
                    polybar = {
                      hostConfig = ./hosts/virtualBox/host.ini;
                      includeSecondary = false;
                    };
                    i3.hostConfig = ./hosts/virtualBox/host.conf;
                  }
                ] ++ sharedImports;
              };
            });

          "twhitney@penguin" =
            let
              pkgs = import nixpkgs {
                inherit system;
                overlays = overlays ++ [
                  nixgl.overlay
                  (import ./nix/hosts/penguin.nix).overlay
                ];
                config = { allowUnfree = true; };
              };
            in
            home-manager.lib.homeManagerConfiguration
              (baseConfig // {
                inherit pkgs;
                system = "x86_64-linux";
                configuration = sharedConfig // {
                  imports = [
                    ./nix/home-manager/tmux.nix
                    ./nix/home-manager/kitty.nix
                    ./nix/home-manager/alacritty.nix
                    {
                      programs.neovim = {
                        withLspSupport = false;
                        package = pkgs.neovim-nightly;
                      };
                    }
                  ] ++ sharedImports;

                  programs.zsh.sessionVariables = {
                    GPG_TTY = "$(tty)";
                  };
                };
              });

          "twhitney@newImage" = home-manager.lib.homeManagerConfiguration
            (baseConfig // {
              inherit pkgs;
              system = "x86_64-linux";
              configuration = sharedConfig // {
                imports = [{
                  programs.neovim = {
                    withLspSupport = true;
                    package = pkgs.neovim-nightly;
                  };
                }] ++ sharedImports;

                programs.zsh.sessionVariables = { GPG_TTY = "$(tty)"; };
              };
            });
        };
    };
}

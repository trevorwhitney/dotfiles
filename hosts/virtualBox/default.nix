let
  system = "x86_64-linux";

  neovim-nightly-overlay =
    builtins.getFlake "github:nix-community/neovim-nightly-overlay";
  dotfiles = builtins.getFlake (toString ../../nix/flakes/dotfiles);
  secrets = builtins.getFlake
    "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=ea38cf5ecec5b6a0eebb8bbe1416bcff4bea55aa";
  unstable = import <nixpkgs-unstable> { };

  overlay = final: prev: {
    inherit unstable;

    i3-gnome-flashback =
      prev.callPackage ../../nix/flakes/i3-gnome-flashback/default.nix {
        inherit (prev) runCommand;
      };
  };
  overlays =
    [ overlay neovim-nightly-overlay.overlay dotfiles.overlay secrets.overlay ];

  pkgs = import <nixpkgs> {
    inherit system overlays;
    config = { allowUnfree = true; };
  };

  # this creates a helper function that abstracts a bit of the boilerplate away
  # `mkVM` takes one argument, a list of `modules` to include in the image.
  mkVM = mods:
    (import <nixpkgs/nixos/lib/eval-config.nix> {
      modules =
        let inherit (pkgs) lib;
        in
        [
          {
            nixpkgs.pkgs = pkgs;
          }
          # base virtualbox config
          {
            imports = [ ./base.nix ];
          }
          # custom configuration
          { imports = [ ./configuration.nix ]; }
        ] ++ mods;
    }).config.system.build.virtualBoxOVA;

  # home-manager = import <home-manager/nixos> { };
in
{
  # delcares the target of an example image with gnome
  # build with: nix-build . -A withGnome
  withGnome = mkVM [
    # add some custom pkgs like vim and tmux, could be our internal packages
    { imports = [ ../../nix/modules/desktops/gnome-i3.nix ]; }
  ];

  withGnomeAndHM = mkVM [
    {
      imports = [
        ../../nix/modules/desktops/gnome-i3.nix
        ../../nix/modules/gui-apps.nix
      ];
    }
    # home-manager.nixosModules.home-manager
    { imports = [ <home-manager/nixos> ]; }
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.twhitney = {
        home.stateVersion = "22.05";

        imports = [
          ../../nix/home-manager/alacritty.nix
          ../../nix/home-manager/bash.nix
          ../../nix/home-manager/common.nix
          ../../nix/home-manager/git.nix
          ../../nix/home-manager/gnome.nix
          ../../nix/home-manager/i3.nix
          ../../nix/home-manager/kitty.nix
          ../../nix/home-manager/neovim.nix
          ../../nix/home-manager/polybar.nix
          ../../nix/home-manager/tmux.nix
          ../../nix/home-manager/xdg.nix
          ../../nix/home-manager/zsh.nix
          {
            programs.git.gpgPath = "/usr/bin/gpg";
            programs.firefox.enable = true;
            programs.neovim = {
              withLspSupport = false;
              package = pkgs.neovim-nightly;
            };
            polybar = {
              hostConfig = ./host.ini;
              includeSecondary = false;
            };
            i3.hostConfig = ./host.conf;
          }
        ];

        programs.git.includes =
          [{ path = "${secrets.defaultPackage.${system}}/git"; }];

        programs.zsh.sessionVariables = {
          LD_LIBRARY_PATH =
            "${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
        };
      };
    }
  ];

  media = mkVM [
    {
      imports = [
        ../../nix/modules/desktops/gnome-shell.nix
        {
          environment.systemPackages = with pkgs; [
            firefox
            google-chrome
            kitty
            vlc
          ];
        }
      ];
    }
    # home-manager.nixosModules.home-manager
    { imports = [ <home-manager/nixos> ]; }
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.twhitney = {
        home.stateVersion = "22.05";

        imports = [
          ../../nix/home-manager/bash.nix
          ../../nix/home-manager/common.nix
          ../../nix/home-manager/git.nix
          ../../nix/home-manager/gnome.nix
          ../../nix/home-manager/kitty.nix
          ../../nix/home-manager/neovim.nix
          ../../nix/home-manager/tmux.nix
          ../../nix/home-manager/xdg.nix
          ../../nix/home-manager/zsh.nix
          {
            programs.git.gpgPath = "/usr/bin/gpg";
            programs.firefox.enable = true;
            programs.neovim = {
              withLspSupport = false;
              package = pkgs.neovim-nightly;
            };
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
}

{ self, pkgs, home-manager, agenix, ... }:
let
  goPkg = pkgs.go_1_23;
  nodeJsPkg = pkgs.nodejs_20;
in
[
  {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages =
      with pkgs; [
        goPkg
        nodeJsPkg

        (neovim {
          inherit goPkg nodeJsPkg;
          withLspSupport = true;
        })

        awscli2
        azure-cli
        bat
        bind
        cmake
        coreutils
        curl
        diffutils
        fd
        fzf
        gnused
        gnumake
        (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
          beta
          alpha
          gke-gcloud-auth-plugin
        ]))
        jq
        k9s
        lsof
        lua51Packages.luarocks
        luajit
        mosh
        ncurses
        ngrok
        nmap
        rbenv
        ripgrep
        unixtools.watch
        virtualenv
        yarn
        yq-go
      ];

    environment.variables = {
      EDITOR = "vim";
    };

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;

    # General Nix settings
    nix = {
      settings = {
        # Necessary for using flakes on this system.
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
      };
      gc.automatic = true;
    };

    # Set Git commit hash for darwin-version.
    system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;

    # The platform the configuration will be used on.
    # nixpkgs.hostPlatform = "aarch64-darwin";
    nixpkgs =
      {
        inherit pkgs;
        hostPlatform = "aarch64-darwin";
      };

    programs = {
      tmux = {
        enable = true;
      };

      direnv = {
        enable = true;
        nix-direnv = { enable = true; };
      };
    };
  }

  ./twhitney.nix
  ./homebrew.nix
  ./remote-build.nix
  ../../modules/desktops/macos.nix

  home-manager.darwinModules.home-manager
  {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      users.twhitney = {
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
]

{ self, pkgs, home-manager, agenix, ... }:
[
  {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages =
      with pkgs; [
        (neovim { withLspSupport = false; })

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
        go
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

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

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
  }

  ./twhitney.nix
  ./homebrew.nix

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

{ self, pkgs, home-manager, agenix, loki, ... }:
let
  goPkg = pkgs.go;
  nodeJsPkg = pkgs.nodejs_22;
in
[
    agenix.nixosModules.default
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
          cloud-sql-proxy
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

    # General Nix settings
    nix = {
      enable = true;
      settings = {
        # Necessary for using flakes on this system.
        experimental-features = "nix-command flakes";
        download-buffer-size = 671088640;
      };
      optimise.automatic = true;
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

    security.pam.services.sudo_local = {
      enable = true;
      reattach = true;
      touchIdAuth = true;
    };
  }

  ./homebrew.nix
  ./remote-build.nix
  ./twhitney.nix
  ./secrets.nix

  ../../modules/desktops/macos.nix
  (import ../../modules/deployment-tools.nix { inherit loki; })

  home-manager.darwinModules.home-manager
  (
  let
    # this is the convulted way to get packages from unstable into home-manager wihtout using complicated overlays
    # inherit (pkgs) jujutsu deployment-tools lazyjj;
    inherit (pkgs) jujutsu lazyjj;
  in
  {
    home-manager = {
      useGlobalPkgs = true;
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

        # make sure inherited packages are use in this configuration block
        programs.jujutsu.package = jujutsu;

        home.packages = [
          lazyjj
        ];
      };
    };
  })
]

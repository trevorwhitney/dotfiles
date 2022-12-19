{ pkgs
, system
, home-manager
, username
, nur
, imports ? [ ]
, config ? { }
, ...
}:
let
  inherit (import ./common.nix { inherit pkgs; }) nixGLWrapWithName nixGLWrap;
  baseConfig = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  kittyPkg = nixGLWrap pkgs.kitty;

  nurPkgs = import nur { inherit pkgs; };
in
{
  "twhitney@cerebral" = home-manager.lib.homeManagerConfiguration
    (baseConfig // {
      inherit pkgs system;
      configuration = config // {
        imports = [
          ./modules/gnome.nix
          ./modules/i3.nix
          ./modules/polybar.nix
          ./modules/spotify.nix
          ./modules/alacritty.nix
          ./modules/kitty.nix
          ./modules/firefox.nix
        ] ++ imports;

        home.packages = with pkgs; [
          # nixGL wrapped
          (nixGLWrap pkgs._1password-gui)
          (nixGLWrapWithName pkgs.google-chrome-beta "google-chrome-beta")
          (nixGLWrapWithName pkgs.spotify "spotify")
        ];

        programs.firefox = {
          package =
            let
              # firefox requires --impure flag because of how it pulls binaries
              unwrapped = nixGLWrapWithName pkgs.latest.firefox-nightly-bin.unwrapped "firefox";
            in
            pkgs.wrapFirefox unwrapped
              {
                cfg = {
                  enableTridactylNative = true;
                };
              };
          extensions = with nurPkgs.repos.rycee.firefox-addons; [
            auto-tab-discard
            cookie-autodelete
            ghostery
            gnome-shell-integration
            https-everywhere
            multi-account-containers
            okta-browser-plugin
            onepassword-password-manager
            privacy-badger
            privacy-possum
            tree-style-tab
            tridactyl
            ublock-origin
          ];
        };
        programs.alacritty = {
          package = nixGLWrap pkgs.alacritty;
        };
        programs.kitty = {
          package = kittyPkg;
        };
        programs.neovim = {
          withLspSupport = true;
        };
        programs.git.includes =
          [{ path = "${pkgs.secrets}/git"; }];

        polybar = {
          hostConfig = ../../hosts/cerebral/host.ini;
          includeSecondary = true;
        };
        i3 = {
          hostConfig = ../../hosts/cerebral/host.conf;
          terminal.command = "${kittyPkg}/bin/kitty --single-instance";
        };
      };
    });
}

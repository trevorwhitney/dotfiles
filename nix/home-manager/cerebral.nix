{ pkgs
, system
, home-manager
, username
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
        ] ++ imports;

        home.packages = with pkgs; [
          flatpak

          # nixGL wrapped
          (nixGLWrap pkgs._1password-gui)
          (nixGLWrapWithName pkgs.google-chrome "google-chrome-stable")
          (nixGLWrap pkgs.slack)
          (nixGLWrapWithName pkgs.spotify "spotify")
        ];

        programs.firefox = {
          enable = true;
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

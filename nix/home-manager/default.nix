{ pkgs, system, home-manager, ... }:
let
  username = "twhitney";
  homeDirectory = "/home/${username}";
  baseConfig = { inherit username homeDirectory; };

  sharedImports = [
    ./modules/common.nix
    ./modules/bash.nix
    ./modules/git.nix
    { programs.git.gpgPath = "/usr/bin/gpg"; }
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/xdg.nix
    ./modules/zsh.nix
  ];
  sharedConfig = {
    programs.git.includes =
      [{ path = "${pkgs.secrets}/git"; }];
  };
in
{
  "twhitney@cerebral" =
    let
      nixGLWrapWithName = pkg: name:
        let
          wrapped = pkgs.writeScriptBin "${name}-wrapped" ''
            #!${pkgs.stdenv.shell}
            ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkg}/bin/${name} "$@"
          '';
          installString = "install -m755 ${wrapped}/bin/${name}-wrapped $out/bin/${name}";
        in
        pkg.overrideAttrs
          (old: {
            postInstall =
              if (builtins.hasAttr "postInstall" old) then ''
                ${old.postInstall}
                ${installString}
              '' else ''
                ${installString}
              '';
          });

      nixGLWrap = pkg: nixGLWrapWithName pkg pkg.pname;
    in
    home-manager.lib.homeManagerConfiguration
      (baseConfig // {
        inherit pkgs system;
        configuration = sharedConfig // {
          imports = [
            ./modules/gnome.nix
            ./modules/i3.nix
            ./modules/polybar.nix
            ./modules/spotify.nix
            ./modules/alacritty.nix
            ./modules/kitty.nix
            {
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
                package = nixGLWrap pkgs.kitty;
              };
              programs.neovim = {
                withLspSupport = true;
              };
              polybar = {
                hostConfig = ../../hosts/cerebral/host.ini;
                includeSecondary = true;
              };
              i3.hostConfig = ../../hosts/cerebral/host.conf;
            }
          ] ++ sharedImports;
        };
      });
}

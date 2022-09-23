{
  # This patches OpenGL apps to work on non NixOS systems
  overlay = final: prev:
    let
      nixGLWrapWithName = pkg: name:
        let
          wrapped = prev.writeScriptBin "${name}" ''
            #!${prev.stdenv.shell}
            ${prev.nixgl.auto.nixGLDefault}/bin/nixGL ${pkg}/bin/${name} "$@"
          '';
          installString = "install -m755 ${wrapped}/bin/${name} $out/bin/${name}";
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
    {
      _1password-gui = nixGLWrap prev._1password-gui;
      alacritty = nixGLWrap prev.alacritty;
      kitty = nixGLWrap prev.kitty;
      google-chrome = nixGLWrapWithName prev.google-chrome "google-chrome-stable";
      slack = nixGLWrap prev.slack;
      spotify = nixGLWrapWithName prev.spotify "spotify";

      # firefox requires --impure flag because of how it pulls binaries
      firefox =
        let
          unwrapped = nixGLWrapWithName prev.latest.firefox-nightly-bin.unwrapped "firefox";
        in
        prev.wrapFirefox unwrapped
          {
            cfg = {
              enableTridactylNative = true;
            };
          };
    };
}

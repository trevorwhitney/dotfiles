{
  # This patches OpenGL apps to work on non NixOS systems
  overlay = final: prev:
    let
      nixGLWrapWithName = pkg: name:
        let
          wrapped = prev.writeScriptBin "${name}" ''
            #!${prev.stdenv.shell}
            ${prev.nixgl.nixGLIntel}/bin/nixGLIntel ${pkg}/bin/${name} "$@"
          '';
        in
        pkg.overrideAttrs
          (old: {
            postInstall = ''
              install -m755 ${wrapped}/bin/${name} $out/bin/${name}
            '';
          });

      nixGLWrap = pkg: nixGLWrapWithName pkg pkg.name;
    in
    {
      _1password-gui = nixGLWrap prev._1password-gui;
      kitty = nixGLWrap prev.kitty;
      google-chrome = nixGLWrapWithName prev.google-chrome "google-chrome-stable";
      slack = nixGLWrap prev.slack;
      spotify = nixGLWrapWithName prev.spotify "spotify";

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

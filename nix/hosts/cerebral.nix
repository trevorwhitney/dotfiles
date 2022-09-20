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
      kitty = nixGLWrap prev.kitty;
      slack = nixGLWrap prev.slack;
      _1password-gui = nixGLWrap prev._1password-gui;
      spotify = nixGLWrapWithName prev.spotify "spotify";

      firefox =
        let
          nixgl-wrapped = prev.writeScriptBin "firefox-nixgl" ''
            #!${prev.stdenv.shell}
            ${prev.nixgl.nixGLIntel}/bin/nixGLIntel ${prev.latest.firefox-nightly-bin.unwrapped}/bin/firefox "$@"
          '';
          unwrapped = prev.latest.firefox-nightly-bin.unwrapped.overrideAttrs
            (old: {
              postInstall = ''
                install -m755 ${nixgl-wrapped}/bin/firefox-nixgl $out/bin/firefox
              '';
            });
        in
        prev.wrapFirefox unwrapped
          {
            cfg = {
              enableTridactylNative = true;
            };
          };
    };
}

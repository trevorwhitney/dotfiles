{
  # This patches OpenGL apps to work on non NixOS systems
  overlay = final: prev: {
    kitty =
      let
        wrapped = prev.writeScriptBin "kitty" ''
          #!${prev.stdenv.shell}
          ${prev.nixgl.nixGLIntel}/bin/nixGLIntel ${prev.kitty}/bin/kitty "$@"
        '';
      in
      prev.kitty.overrideAttrs
        (old: {
          postInstall = ''
            install -m755 ${wrapped}/bin/kitty $out/bin/kitty
          '';
        });
  };
}

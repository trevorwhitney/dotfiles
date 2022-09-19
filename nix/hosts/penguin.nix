{
  # This patches OpenGL apps to work on non NixOS systems
  overlay = final: prev: {
    kitty-nixgl =
      let
        wrapped = prev.writeScriptBin "kitty-wrapped" ''
          #!${prev.stdenv.shell}
          ${prev.nixgl.nixGLIntel}/bin/nixGLIntel ${prev.kitty}/bin/kitty "$@"
        '';
      in
      prev.kitty.overrideAttrs
        (old: {
          postInstall = ''
            install -m755 ${wrapped}/bin/kitty-wrapped $out/bin/kitty
          '';
        });
    alacritty-nixgl =
      let
        wrapped = prev.writeScriptBin "alacritty-wrapped" ''
          #!${prev.stdenv.shell}
          ${prev.nixgl.nixGLIntel}/bin/nixGLIntel ${prev.alacritty}/bin/alacritty "$@"
        '';
      in
      prev.alacritty.overrideAttrs
        (old: {
          postInstall = ''
            ${old.postInstall}
            install -m755 ${wrapped}/bin/alacritty-wrapped $out/bin/alacritty
          '';
        });
  };
}

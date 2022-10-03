{ pkgs, ... }:
rec {
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
}

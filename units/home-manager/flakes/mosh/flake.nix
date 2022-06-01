{
  description = "Mosh: the mobile shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlay = (final: prev: {
        mosh = prev.mosh.overrideAttrs (oldAttrs: rec {
          buildInputs = oldAttrs.buildInputs ++ (with prev; [ glibcLocales ]);
          postInstall = with prev; ''
            wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB;
            wrapProgram $out/bin/mosh-server --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive;
          '';
        });
      });
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      {
        defaultPackage = pkgs.mosh;
        devShell = import ./shell.nix { inherit pkgs; };
        packages = { mosh = pkgs.mosh; };
      }));
}

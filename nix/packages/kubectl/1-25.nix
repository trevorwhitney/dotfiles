{ pkgs, system }:
let
  pinnedPkgs = import
    (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify
      allRefs = true;
      name = "pkg-revision-with-kubernetes-1.25.5";
      url = "https://github.com/NixOS/nixpkgs/";
      rev = "79b3d4bcae8c7007c9fd51c279a8a67acfa73a2a";
    })
    { inherit system; };
  version = "1.25.12";
in
pinnedPkgs.kubectl.overrideAttrs (oldAttrs: rec {
  inherit version;
  src = pkgs.fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "eGvTzBNFevHi3qgqzdURH6jGUeKjwJxYfzPu+tGa294=";
  };
})

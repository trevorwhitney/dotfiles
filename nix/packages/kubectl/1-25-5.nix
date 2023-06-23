{ pkgs, system }:
let
  pinnedPkgs = import
    (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify
      name = "pkg-revision-with-kubernetes-1.25.5";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "79b3d4bcae8c7007c9fd51c279a8a67acfa73a2a";
    })
    { inherit system; };
in
pinnedPkgs.kubectl

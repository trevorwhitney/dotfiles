{ pkgs, stdenv, ... }:
let
  pinnedPkgs =
    import
      (builtins.fetchGit {
        # Descriptive name to make the store path easier to identify
        name = "chart-testing-3.8.0";
        url = "https://github.com/NixOS/nixpkgs/";
        ref = "refs/heads/nixpkgs-unstable";
        rev = "5a8650469a9f8a1958ff9373bd27fb8e54c4365d";
      })
      {
        system = stdenv.hostPlatform.system;
      };
in
pinnedPkgs.chart-testing

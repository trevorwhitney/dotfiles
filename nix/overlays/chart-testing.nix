final: prev: {
  chart-testing-3_8_0 = import ../packages/chart-testing/3_8_0.nix {
    inherit (final) system;
    pkgs = prev;
  };
}

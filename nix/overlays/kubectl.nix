final: prev: {
  kubectl-1-22 = import ../packages/kubectl/1-22.nix {
    inherit (final) system;
    pkgs = prev;
  };
  kubectl-1-25 = import ../packages/kubectl/1-25.nix {
    inherit (final) system;
    pkgs = prev;
  };
}

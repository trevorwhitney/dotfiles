{ system }: final: prev: {
  kubectl-1-22-15 = import ../packages/kubectl/1-22-15.nix {
    inherit system;
    pkgs = prev;
  };
  kubectl-1-25-5 = import ../packages/kubectl/1-25-5.nix {
    inherit system;
    pkgs = prev;
  };
}

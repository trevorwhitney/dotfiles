final: prev: {
  pex = import ../packages/pex {
    inherit (final) lib buildGoModule fetchFromGitHub;
    pkgs = prev;
  };
}

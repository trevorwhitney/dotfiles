final: prev: {
  faillint = import ../packages/faillint {
    inherit (prev) lib buildGoModule fetchFromGitHub;
  };
}

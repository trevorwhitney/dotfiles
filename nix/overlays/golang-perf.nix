final: prev: {
  golang-perf = import ../packages/golang-perf {
    inherit (prev) lib buildGoModule fetchFromGitHub;
  };
}

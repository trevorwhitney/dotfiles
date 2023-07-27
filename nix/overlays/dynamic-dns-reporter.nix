final: prev: {
  dynamic-dns-reporter = import ../packages/dynamic-dns-reporter {
    inherit (prev) lib buildGoModule fetchFromGitHub;
  };
}

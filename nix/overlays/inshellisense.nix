final: prev: {
  inshellisense = import ../packages/inshellisense {
    inherit (final) lib buildNpmPackage fetchFromGitHub;
  };
}

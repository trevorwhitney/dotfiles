final: prev: {
  mixtool = import ../packages/mixtool { inherit (prev) lib buildGoModule fetchFromGitHub; };
}

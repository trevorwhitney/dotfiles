[
  # loki
  (final: prev: {
    loki = import ../packages/loki.nix { pkgs = prev; };
    mixtool = import ../../../packages/mixtool { inherit (prev) lib buildGoModule fetchFromGitHub; };
  })
]

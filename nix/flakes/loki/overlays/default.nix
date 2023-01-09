[
  # loki
  (final: prev: {
    loki = import ../packages/loki.nix { pkgs = prev; };
  })
]

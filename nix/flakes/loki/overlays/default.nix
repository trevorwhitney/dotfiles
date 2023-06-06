[
  # loki
  (final: prev:
    let
      pkgs = import ../packages { pkgs = prev; };
    in
    {
      inherit (pkgs) loki loki-canary logcli promtail;
      mixtool = import ../../../packages/mixtool { inherit (prev) lib buildGoModule fetchFromGitHub; };
    })
]

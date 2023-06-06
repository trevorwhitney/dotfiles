{pkgs}: rec {
  loki = import ../packages/loki.nix {inherit pkgs; };

  loki-canary = import ../packages/loki-canary.nix {inherit loki; };
  logcli = import ../packages/logcli.nix {inherit loki; };
  promtail = import ../packages/promtail.nix {inherit pkgs loki; };
}

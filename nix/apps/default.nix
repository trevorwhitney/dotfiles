{ pkgs, loki, secrets, ... }:
let
  deploymentTools = builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "deployment-tools";
    url = "https://github.com/grafana/deployment_tools";
    rev = "2df5edd74eacece52f7f3f3974de9285cceca1c8";
  };

  # overlays needed for loki
  packages = pkgs.extend
    (self: super: with super.lib;
    (foldl' (flip extends) (_: super)
      [
        loki.overlays.default
        secrets.overlay

        (import ../overlays/golang-perf.nix)
        (import ../overlays/chart-testing.nix)
      ]
      self
    ));
in
{
  loki = {
    type = "app";
    program = "${packages.loki.overrideAttrs(old: { doCheck = false; })}/bin/loki";
  };
  promtail = {
    type = "app";
    program = "${packages.promtail.overrideAttrs(old: { doCheck = false; })}/bin/promtail";
  };
  logcli = {
    type = "app";
    program = "${packages.logcli.overrideAttrs(old: { doCheck = false; })}/bin/logcli";
  };
  loki-canary = {
    type = "app";
    program = "${packages.loki-canary.overrideAttrs(old: { doCheck = false; })}/bin/loki-canary";
  };
}

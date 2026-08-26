{ config, pkgs, lib, ... }:
let
  stateDir = "${config.home.homeDirectory}/.local/state/agento11y";
  agento11yBin = "/opt/homebrew/bin/agento11y";

  # agento11y comes from homebrew, whose bundle runs in system activation, so
  # the binary can still be missing on a first build. Wait rather than let
  # KeepAlive spin on a failed exec.
  run-agento11y-receiver = pkgs.writeShellApplication {
    name = "run-agento11y-receiver";
    text = ''
      until [ -x "${agento11yBin}" ]; do
        echo "waiting for ${agento11yBin}"
        sleep 5
      done

      exec "${agento11yBin}" local serve
    '';
  };
in
{
  home.activation.agento11yStateDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${stateDir}"
  '';

  # The opencode plugin never starts a receiver of its own: with
  # AGENTO11Y_LOCAL=true it attaches to a running one, and skips capture
  # entirely when there is none rather than falling back to Grafana Cloud. Only
  # one instance may run; a second `local serve` truncates the status file that
  # the plugin reads to find the receiver.
  launchd.agents.agento11y = {
    enable = true;
    config = {
      Program = "${run-agento11y-receiver}/bin/run-agento11y-receiver";
      RunAtLoad = true;
      KeepAlive = true;
      EnvironmentVariables.PATH = lib.concatStringsSep ":" [
        "/opt/homebrew/bin"
        "/run/current-system/sw/bin"
        "/usr/bin"
        "/bin"
      ];
      StandardOutPath = "${stateDir}/receiver.out.log";
      StandardErrorPath = "${stateDir}/receiver.err.log";
    };
  };
}

{ config, pkgs, lib, ... }:
let
  stateDir = "${config.home.homeDirectory}/.local/state/telegraf";
  agento11yConfig = "${config.home.homeDirectory}/.config/agento11y/config.env";

  # Per-harness CPU/memory for the coding-agent CLIs, matched by executable
  # basename (not cmdline) so shell wrappers and hook scripts that merely
  # mention the name don't get picked up. pid_finder = "native" avoids
  # shelling out to pgrep, which fails under this machine's agent sandbox
  # (sysmond lookups are denied there); tag_with = ["pid"] keeps concurrent
  # instances of the same harness as distinct series instead of colliding on
  # one label set. cmdline is dropped because it can contain full task
  # prompts, which have no business leaving this machine as metric data.
  telegrafConfig = pkgs.writeText "telegraf.toml" ''
    [agent]
      interval = "30s"
      round_interval = true
      flush_interval = "30s"

    [global_tags]
      host = "fiction"

    [[inputs.procstat]]
      exe = "claude"
      pid_finder = "native"
      tag_with = ["pid"]
      fielddrop = ["cmdline"]
      [inputs.procstat.tags]
        harness = "claude"

    [[inputs.procstat]]
      exe = "codex"
      pid_finder = "native"
      tag_with = ["pid"]
      fielddrop = ["cmdline"]
      [inputs.procstat.tags]
        harness = "codex"

    [[inputs.procstat]]
      exe = "opencode"
      pid_finder = "native"
      tag_with = ["pid"]
      fielddrop = ["cmdline"]
      [inputs.procstat.tags]
        harness = "opencode"

    # Reuses agento11y's already-provisioned Grafana Cloud OTLP gateway and
    # tenant. The Authorization value is injected at process start from
    # agento11y's own config.env (see run-telegraf below) so the token never
    # lands in the world-readable /nix/store.
    [[outputs.opentelemetry]]
      service_address = "https://otlp-gateway-prod-us-west-0.grafana.net/otlp/v1/metrics"
      compression = "gzip"
      [outputs.opentelemetry.headers]
        Authorization = "''${OTEL_BASIC_AUTH}"
  '';

  run-telegraf = pkgs.writeShellApplication {
    name = "run-telegraf";
    text = ''
      # shellcheck disable=SC1090,SC1091
      source "${agento11yConfig}"
      export OTEL_BASIC_AUTH="''${OTEL_EXPORTER_OTLP_HEADERS#Authorization=}"
      exec "${pkgs.telegraf}/bin/telegraf" --config "${telegrafConfig}"
    '';
  };
in
{
  home.activation.telegrafStateDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${stateDir}"
  '';

  launchd.agents.telegraf = {
    enable = true;
    config = {
      Program = "${run-telegraf}/bin/run-telegraf";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${stateDir}/telegraf.out.log";
      StandardErrorPath = "${stateDir}/telegraf.err.log";
    };
  };
}

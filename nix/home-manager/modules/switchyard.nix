{ pkgs, config, ... }:
let
  routes = pkgs.writeTextFile {
    name = "switchyard-routes.toml";
    text = ''
      schema_version = 1

      [llm_clients.anthropic]
      format = "anthropic_messages"
      base_url = "https://api.anthropic.com"
      api_key_env = "ANTHROPIC_API_KEY"

      [targets.sonnet]
      id = "claude-sonnet-5"
      llm_client = "anthropic"

      [targets.haiku]
      id = "claude-haiku-4-5-20251001"
      llm_client = "anthropic"

      [routes.explore]
      id = "explore-cheap"
      type = "passthrough"
      target = "haiku"
      tool_calling = true
      context_window = 200000

      [routes.impl]
      id = "impl-smart"
      type = "stage_router"
      capable_target = "sonnet"
      efficient_target = "haiku"
      picker = "efficient_first"
      confidence_threshold = 0.5
      tool_calling = true
      context_window = 200000
    '';
  };

  run-switchyard = pkgs.writeShellApplication {
    name = "run-switchyard";
    text = ''
      # agenix decrypts secrets after login; wait so KeepAlive restarts converge
      anthropic_key_file="${config.age.secrets.anthropicApiKey.path}"
      until [ -s "$anthropic_key_file" ]; do
        echo "waiting for agenix secret $anthropic_key_file"
        sleep 2
      done

      ANTHROPIC_API_KEY="$(cat "$anthropic_key_file")" \
        SWITCHYARD_TELEMETRY_OPT_OUT=1 \
        exec ${pkgs.switchyard-server}/bin/switchyard-server \
        --config ${routes} --host 127.0.0.1 --port 4000
    '';
  };
in
{
  launchd.agents.switchyard = {
    enable = true;
    config = {
      Program = "${run-switchyard}/bin/run-switchyard";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/switchyard.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/switchyard.stderr.log";
    };
  };
}

{ config, pkgs, lib, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/workspace/dotfiles/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  stateDir = "${config.home.homeDirectory}/.local/state/agentd";
  runAgentd = pkgs.writeShellApplication {
    name = "run-agentd";
    text = ''
      # agenix decrypts secrets after login; KeepAlive retries until both
      # provider credentials are available without putting them in the store.
      openai_key_file="${config.age.secrets.openAiKey.path}"
      anthropic_key_file="${config.age.secrets.anthropicApiKey.path}"
      until [ -s "$openai_key_file" ] && [ -s "$anthropic_key_file" ]; do
        echo "waiting for agentd provider credentials"
        sleep 2
      done

      CODEX_API_KEY="$(${pkgs.coreutils}/bin/cat "$openai_key_file")"
      ANTHROPIC_API_KEY="$(${pkgs.coreutils}/bin/cat "$anthropic_key_file")"
      export CODEX_API_KEY ANTHROPIC_API_KEY
      exec ${pkgs.agentd}/bin/agentd serve
    '';
  };
in
{
  home.packages = [
    pkgs.agentctl
    pkgs.agentd
  ];

  xdg.configFile."agentd/config.yaml".source = mkSymlink "${dotfilesPath}/agentd/config.yaml";

  home.activation.agentdStateDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${stateDir}"
  '';

  launchd.agents.agentd = {
    enable = true;
    config = {
      Program = "${runAgentd}/bin/run-agentd";
      RunAtLoad = true;
      KeepAlive = true;
      # launchd agents get a minimal PATH; the daemon shells out to gh, git,
      # tmux, nvim, codex, and claude.
      EnvironmentVariables.PATH = lib.concatStringsSep ":" [
        "${config.home.homeDirectory}/.nix-profile/bin"
        "/etc/profiles/per-user/${config.home.username}/bin"
        "/run/current-system/sw/bin"
        "/opt/homebrew/bin"
        "${config.home.homeDirectory}/.local/bin"
        "/usr/bin"
        "/bin"
      ];
      StandardOutPath = "${stateDir}/agentd.log";
      StandardErrorPath = "${stateDir}/agentd.log";
    };
  };
}

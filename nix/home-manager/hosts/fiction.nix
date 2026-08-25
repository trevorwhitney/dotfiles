{ config, ... }:
{
  imports = [
    ../modules/1password.nix
    ../modules/agentd.nix
    ../modules/android.nix
    ../modules/bash.nix
    ../modules/change-background.nix
    ../modules/claude-code.nix
    ../modules/darwin.nix
    ../modules/env.nix
    ../modules/ghostty
    ../modules/git.nix
    ../modules/kubernetes.nix
    ../modules/tmux.nix
    ../modules/zed.nix
    ../modules/node.nix
    ../modules/opencode.nix
    ../modules/switchyard.nix
    ../modules/zsh.nix
  ];

  targets.darwin = {
    defaults = { };
    search = "Google";
  };

  # for debugging agenix secrets
  # home.packages = [
  #   (pkgs.writeShellScriptBin "echo-secret" ''
  #     ${pkgs.coreutils}/bin/cat ${config.age.secrets.openAiKey.path}
  #   '')
  # ];

  age = {
    secrets = {
      anthropicApiKey.file = ../../secrets/anthropicApiKey.age;
      ghToken.file = ../../secrets/ghToken.age;
      ollamaCredentials.file = ../../secrets/ollamaCredentials.age;
      openAiKey.file = ../../secrets/openAiKey.age;
      openRouterApiKey.file = ../../secrets/openRouterApiKey.age;
      "deploymentTools.sh".file = ../../secrets/deploymentTools.sh.age;
      grafana.file = ../../secrets/grafana.age;
      apiKeys.file = ../../secrets/apiKeys.age;
    };
    secretsDir = "${config.home.homeDirectory}/.agenix/secrets";
    identityPaths = [ "${config.home.homeDirectory}/.config/agenix/id_ed25519" ];
  };

  programs = {
    _1password = {
      host.darwin = true;
    };
    gh = {
      enable = true;
    };

    kubectl = {
      enable = true;
    };

    tmux = {
      theme = "everforest";
    };

    ssh = {
      settings = {
        "exit-node" = {
          User = "twhitney";
          HostName = "24.199.116.208";
          ForwardAgent = false;
        };
        "remy" = {
          User = "twhitney";
          HostName = "10.11.0.15";
          ForwardAgent = false;
        };
      };
    };

    zsh = {
      useDotNetTools = true;
      includeSecrets = true;
    };
  };
}

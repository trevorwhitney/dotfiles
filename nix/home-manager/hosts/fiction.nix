{ config, ... }:
{
  imports = [
    ../modules/1password.nix
    ../modules/android.nix
    ../modules/bash.nix
    ../modules/change-background.nix
    ../modules/darwin.nix
    ../modules/ghostty.nix
    ../modules/git.nix
    ../modules/kubernetes.nix
    ../modules/tmux.nix
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
      git.file = ../../secrets/git.age;
      ollamaCredentials.file = ../../secrets/ollamaCredentials.age;
      openAiKey.file = ../../secrets/openAiKey.age;
      openRouterApiKey.file = ../../secrets/openRouterApiKey.age;
      "deploymentTools.sh".file = ../../secrets/deploymentTools.sh.age;
      grafana.file = ../../secrets/grafana.age;
    };
    secretsDir = "${config.home.homeDirectory}/.agenix/secrets";
    identityPaths = [ "${config.home.homeDirectory}/.config/agenix/id_ed25519" ];
  };

  programs = {
    _1password = {
      host.darwin = true;
    };
    git = {
      includes = [ { path = "${config.age.secrets.git.path}"; } ];
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
      matchBlocks = {
        "exit-node" = {
          user = "twhitney";
          host = "exit-node";
          hostname = "24.199.116.208";
          forwardAgent = false;
        };
        "jerry" = {
          user = "twhitney";
          host = "jerry";
          hostname = "10.11.0.52";
          forwardAgent = false;
        };
        "mickey" = {
          user = "twhitney";
          host = "mickey";
          hostname = "10.11.0.74";
          forwardAgent = true;
        };
        "monterey" = {
          user = "twhitney";
          host = "monterey";
          hostname = "10.11.0.51";
          forwardAgent = false;
        };
        "omada" = {
          host = "omada";
          hostname = "10.11.0.72";
          forwardAgent = true;
        };
        "proxmox" = {
          user = "twhitney";
          host = "proxmox";
          hostname = "10.11.0.100";
          forwardAgent = true;
        };
      };
    };

    zsh = {
      useDotNetTools = true;
      includeSecrets = true;
    };
  };
}

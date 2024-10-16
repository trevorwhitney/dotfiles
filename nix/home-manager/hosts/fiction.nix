{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/1password.nix
    ../modules/android.nix
    ../modules/bash.nix
    ../modules/change-background.nix
    ../modules/darwin.nix
    ../modules/grafana.nix
    ../modules/git.nix
    ../modules/kubernetes.nix
    ../modules/neovim.nix
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
  #     ${pkgs.coreutils}/bin/cat ${config.age.secrets.openApiKey.path}
  #   '')
  # ];

  age = {
    secrets = {
      openApiKey.file = ../../secrets/openApiKey.age;
      anthropicApiKey.file = ../../secrets/anthropicApiKey.age;
    };
    secretsDir = "${config.home.homeDirectory}/.agenix/secrets";
    identityPaths = [ "${config.home.homeDirectory}/.config/agenix/id_ed25519" ];
  };

  # TODO: do we still need this AND zsh.envExtra?
  home.sessionVariables = {
    OPENAI_API_KEY = "$(${pkgs.coreutils}/bin/cat ${config.age.secrets.openApiKey.path})";
    ANTHROPIC_API_KEY = "$(${pkgs.coreutils}/bin/cat ${config.age.secrets.anthropicApiKey.path})";
  };

  programs = {
    _1password = {
      host.darwin = true;
    };
    git = {
      includes =
        [{ path = "${pkgs.secrets}/git"; }];
    };

    neovim =
      let
        withLspSupport = true;
      in
      {
        inherit withLspSupport;

        package = pkgs.neovim {
          # TODO: need to pass down go and node packageS?
          inherit withLspSupport;
        };
      };

    gh = {
      enable = true;
    };

    kubectl = {
      enable = true;
      package = pkgs.kubectl-1-25;
    };

    tmux = {
      theme = "everforest";
    };

    ssh = {
      matchBlocks = {
        "mickey" = {
          host = "mickey";
          hostname = "10.11.0.56";
          # this is to enable remote builds, but those aren't working
          # identityFile = "${config.home.homeDirectory}/.config/agenix/id_ed25519";
          forwardAgent = true;
        };
        "monterey" = {
          host = "monterey";
          hostname = "10.11.0.51";
          forwardAgent = true;
        };
      };
    };
  };
}

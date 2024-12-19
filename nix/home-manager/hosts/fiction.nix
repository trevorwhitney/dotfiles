{ config, pkgs, ... }: {
  imports = [
    ../modules/1password.nix
    ../modules/android.nix
    ../modules/bash.nix
    ../modules/change-background.nix
    ../modules/darwin.nix
    ../modules/git.nix
    ../modules/kubernetes.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
  ];

  targets.darwin = {
    defaults = { };
    search = "Google";
  };

  # TODO: why doesn't this work?
  # the package is only available if added via an overlay, but not via a merge in the top flake.nix
  # home.packages = builtins.trace "!!! where is this package: ${pkgs.deployment-tools}" [
  #   pkgs.deployment-tools
  # ];

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

  programs = {
    _1password = {
      host.darwin = true;
    };
    git = {
      includes =
        [{ path = "${pkgs.secrets}/git"; }];
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
        "mickey" = {
          host = "mickey";
          hostname = "10.11.0.74";
          # this is to enable remote builds, but those aren't working
          # identityFile = "${config.home.homeDirectory}/.config/agenix/id_ed25519";
          forwardAgent = true;
        };
        "monterey" = {
          host = "monterey";
          hostname = "10.11.0.51";
          forwardAgent = true;
        };
        "omada" = {
          host = "omada";
          hostname = "10.11.0.72";
          forwardAgent = true;
        };
      };
    };

    zsh.useDotNetTools = true;
  };
}

{ cfg
, home-manager
, imports
, pkgs
, username
, ...
}:
let
  _imports = [
    ../modules/1password.nix
    ../modules/bash.nix
    ../modules/change-background.nix
    ../modules/darwin.nix
    ../modules/grafana.nix
    ../modules/git.nix
    ../modules/kubernetes.nix
    ../modules/neovim.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
  ] ++ imports;

  homeDirectory = "/Users/${username}";

  baseConfig = {
    home = {
      inherit homeDirectory username;
      stateVersion = "23.11";
    };
  };
in
{
  "twhitney@fiction" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      baseConfig
      cfg
      ({ config, ... }: {
        targets.darwin = {
          defaults = { };
          search = "Google";
        };

        home.packages = [
          (pkgs.writeShellScriptBin "echo-secret" ''
            ${pkgs.coreutils}/bin/cat ${config.age.secrets.openApiKey.path}
          '')
        ];

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
              withLspSupport = false;
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
      })
    ] ++ _imports;
  };
}

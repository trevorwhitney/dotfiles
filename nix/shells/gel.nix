{ pkgs, ... }:
let
  developmentTools = import ../development-tools.nix { inherit pkgs; };
in
pkgs.mkShell {
  # Retain compiler setup for project builds, including CGO.
  packages = pkgs.lib.optionals (!pkgs.stdenv.isDarwin) (developmentTools.packages ++ (with pkgs; [
      nixpkgs-fmt
      statix
    ]))
    ++ (with pkgs; [
      gcc
      nettools
      snyk
      (pkgs.neovim (developmentTools.editorArgs // {
        goBuildTags = "requires_docker";
        dapConfigurations =
          let
            ports = {
              "Distributor" = 18001;
              "Ingester" = 18002;
              "Querier" = 18004;
              "Query Frontend" = 18007;
              "Pattern Ingester" = 18010;
            };

            remoteDebugConfigs = (builtins.map
              (service: {
                type = "go";
                request = "attach";
                mode = "remote";
                name = "Compose ${service}";
                dlvToolPath = "${pkgs.delve}/bin/dlv";
                remotePath = "/loki/loki";
                port = ports.${service};
                cwd = ''''${workspaceFolder}'';
                showLog = true;
              })
              (builtins.attrNames ports));

          in
          {
            go = [
              {
                type = "go";
                name = "Loki main";
                request = "launch";
                program = ''''${workspaceFolder}/cmd/loki/main.go'';
                args = [
                  ''-config.file=''${workspaceFolder}/cmd/loki/loki-local-config.yaml''
                ];
              }
            ] ++ remoteDebugConfigs;
          };
      }))
    ]);
}

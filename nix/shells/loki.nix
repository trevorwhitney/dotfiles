{ pkgs, ... }:
let
  developmentTools = import ../development-tools.nix { inherit pkgs; };
in
pkgs.mkShell {
  # Retain compiler setup for project builds, including CGO.
  packages = pkgs.lib.optionals (!pkgs.stdenv.isDarwin) (developmentTools.packages ++ (with pkgs; [
      nixpkgs-fmt
      statix
      mariadb.client
      yq-go
    ]))
    ++ (with pkgs; [
      gcc
      nettools
      buf
      crane
      gotestsum
      protobuf_21
      protoc-gen-go
      protoc-gen-go-grpc
      protoc-gen-gogoslick
      (pkgs.neovim (developmentTools.editorArgs // {
        goBuildTags = "integration";
        dapConfigurations =
          let
            ports = {
              "Distributor" = 18001;
              "Ingester" = 18002;
              "Querier" = 18004;
              "Query Frontend" = 18007;
              "Pattern Ingester" = 18010;
              "Partition Ring" = 18020;
              "Dataobj Index Builder" = 18021;
              "Dataobj Consumer" = 18020;
            };

            remoteDebugConfigs = (
              builtins.map (service: {
                type = "go";
                request = "attach";
                mode = "remote";
                name = "Compose ${service}";
                dlvToolPath = "${pkgs.delve}/bin/dlv";
                remotePath = "/loki/loki";
                port = ports.${service};
                cwd = "\${workspaceFolder}";
                showLog = true;
              }) (builtins.attrNames ports)
            );

          in
          {
            go = [
              {
                type = "go";
                name = "Loki main";
                request = "launch";
                program = "\${workspaceFolder}/cmd/loki/main.go";
                args = [
                  "-config.file=\${workspaceFolder}/cmd/loki/loki-local-config.yaml"
                ];
              }
            ]
            ++ remoteDebugConfigs;
          };
      }))

      (pkgs.loki.overrideAttrs (old: {
        doCheck = false;
      }))
    ]);
}

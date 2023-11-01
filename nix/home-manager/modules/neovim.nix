{ config, pkgs, lib, ... }:
let
  inherit (pkgs) jdtls;
  cfg = config.programs.neovim;
in
{
  options = {
    # TODO: add options for go and node packages
    programs.neovim = {
      withLspSupport = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description =
          "whether to enable lsp support and install required dependencies";
      };
    };
  };

  config =
    let
      inherit (cfg) withLspSupport;
    in
    {
      xdg.dataFile."jdtls/config_linux/config.ini" =
        lib.mkIf withLspSupport { source = "${jdtls}/config_linux/config.ini"; };

      # all configuration done in custom neovim package
      home.packages = with pkgs; [
        (neovim.override {
          inherit withLspSupport;
        })
      ];
    };
}

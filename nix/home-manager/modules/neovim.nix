{ config, pkgs, lib, ... }:
let
  inherit (pkgs) jdtls;
  cfg = config.programs.neovim;
in
{
  options = {
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
      inherit (cfg) withLspSupport finalPackage;
      _cc = "${pkgs.stdenv.cc}";
      nodeJsPkg = pkgs.nodejs_18;

    in
    rec {
      xdg.dataFile."jdtls/config_linux/config.ini" =
        lib.mkIf withLspSupport { source = "${jdtls}/config_linux/config.ini"; };
      programs.neovim = {
        enable = true;
        # TODO: when on 23-05
        /* defaultEditor = true; */

        # manually provide node to pin @ version that works with Copilot
        withNodeJs = false;
        package = pkgs.neovim-unwrapped.override {
          nodejs = nodeJsPkg;
        };
        # use own custom script above for starting in tmux
        vimAlias = true;
        vimdiffAlias = true;

        extraConfig =
          let
            exCfg = with pkgs;
              if withLspSupport then [
                # set path the lua language server so we can pass it to respective lsp config
                "let s:lsp_support = 1"
                "let s:lua_ls_path = '${lua-language-server}'"
                "let s:rocks_tree_root = '${lua51Packages.luarocks}'"
                "let g:jdtls_home = '${jdtls}'"
                (lib.strings.fileContents ./lib/init.vim)
              ] else [
                "let s:lsp_support = 1"
                (lib.strings.fileContents ./lib/init.vim)
              ];
          in
          builtins.concatStringsSep "\n" (with pkgs;
          [
            # nvim-treesitter requires gcc and tree-sitter to be in the path as seen by neovim
            "call setenv('PATH', '${_cc}/bin:${tree-sitter}/bin:' . getenv('PATH'))"
          ] ++ exCfg);

        withRuby = true;
        withPython3 = true;
        extraPython3Packages = ps: with ps; [ pynvim ];

        # Will use packer to grab everything else
        plugins = with pkgs.vimPlugins; [ packer-nvim ];

        extraPackages =
          let
            basePackages = with pkgs; [
              gcc
              gnumake
              nixd
              nodeJsPkg
              nodePackages.markdownlint-cli
              rnix-lsp
              statix
            ];
            lspPackages = with pkgs;
              if withLspSupport then [
                stylua
                jdtls

                ccls # c++ language server
                delve
                gopls
                jsonnet-language-server
                lua-language-server
                nixpkgs-fmt
                pyright
                shellcheck
                shfmt
                terraform-ls
                vale
                vim-vint
                yamllint

                nodePackages.bash-language-server
                nodePackages.dockerfile-language-server-nodejs
                nodePackages.eslint
                nodePackages.eslint_d
                nodePackages.fixjson
                nodePackages.neovim
                nodePackages.prettier
                nodePackages.typescript
                nodePackages.typescript-language-server
                nodePackages.vim-language-server
                nodePackages.vscode-langservers-extracted
                nodePackages.write-good
                nodePackages.yaml-language-server

                lua51Packages.luacheck
              ] else [ ];
          in
          with pkgs;
          [
            # required by tree-sitter
            _cc
            tree-sitter
            # end required by tree-sitter

            gnutar
          ] ++ basePackages ++ lspPackages;
      };
    };
}

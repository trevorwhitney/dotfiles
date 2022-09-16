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
      _cc = "${pkgs.unstable.stdenv.cc}";
    in
    rec {
      # always start vim in a tmux pane
      home.file.".local/bin/vim".text = ''
        #!${pkgs.bash}/bin/bash

        current_dir="''$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

        if [[ ! -z "''$@" ]]; then
          dir="''$(dirname ''$@)"
          if [[ -d "''$@" ]]; then
            dir="''$@"
          fi
          pushd ''$dir > /dev/null
          current_dir="''$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
          popd > /dev/null
        fi

        dir_name="''$(basename ''${current_dir})"
        if [[ -z "''${TMUX}" ]]; then
          tmux new-session -A -s "vim ''${dir_name}" -n "''${dir_name}" ${finalPackage}/bin/nvim ''$@
        else
          ${finalPackage}/bin/nvim ''$@
        fi
      '';
      home.file.".local/bin/vim".executable = true;

      xdg.dataFile."jdtls/config_linux/config.ini" =
        lib.mkIf withLspSupport { source = "${jdtls}/config_linux/config.ini"; };
      programs.neovim = {
        enable = true;
        # use own custom script above for starting in tmux
        vimAlias = false;
        vimdiffAlias = true;

        extraConfig =
          let
            exCfg = with pkgs;
              if withLspSupport then [
                # set path the lua language server so we can pass it to respective lsp config
                "let s:lsp_support = 1"
                "let s:sumneko_lua_ls_path = '${sumneko-lua-language-server}'"
                "let s:rocks_tree_root = '${lua51Packages.luarocks}'"
                "let g:jdtls_home = '${jdtls}'"
                (lib.strings.fileContents ./lib/init.vim)
              ] else [
                "let s:lsp_support = 0"
                (lib.strings.fileContents ./lib/init.vim)
              ];
          in
          builtins.concatStringsSep "\n" (with pkgs;
          [
            # nvim-treesitter requires gcc and tree-sitter to be in the path as seen by neovim
            "call setenv('PATH', '${_cc}/bin:${tree-sitter}/bin:' . getenv('PATH'))"
          ] ++ exCfg);

        withNodeJs = true;
        withRuby = true;
        withPython3 = true;
        extraPython3Packages = ps: with ps; [ pynvim ];

        # Will use packer to grab everything else
        plugins = with pkgs.vimPlugins; [ packer-nvim ];

        extraPackages =
          let
            lspPackages = with pkgs;
              if withLspSupport then [
                stylua
                jdtls

                ccls # c++ language server
                delve
                gopls
                jsonnet-language-server
                nixpkgs-fmt
                pyright
                rnix-lsp
                shellcheck
                shfmt
                statix
                sumneko-lua-language-server
                terraform-ls
                vale
                vim-vint
                yamllint

                nodePackages.bash-language-server
                nodePackages.dockerfile-language-server-nodejs
                nodePackages.eslint
                nodePackages.eslint_d
                nodePackages.fixjson
                nodePackages.markdownlint-cli
                nodePackages.neovim
                nodePackages.prettier
                nodePackages.typescript
                nodePackages.typescript-language-server
                nodePackages.vim-language-server
                nodePackages.vscode-langservers-extracted
                nodePackages.write-good
                nodePackages.yaml-language-server
              ] else
                [ ];
          in
          with pkgs;
          [
            # required by tree-sitter
            _cc
            tree-sitter
            # end required by tree-sitter

            gnutar
          ] ++ lspPackages;
      };
    };
}

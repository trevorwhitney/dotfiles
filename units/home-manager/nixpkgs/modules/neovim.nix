{ withLspSupport ? false, config, pkgs, lib }:
let jdtls = pkgs.callPackage ../pkgs/jdtls { };
in
{
  xdg.dataFile."jdtls/config_linux/config.ini" =
    lib.mkIf withLspSupport { source = "${jdtls}/config_linux/config.ini"; };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
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
            (lib.strings.fileContents ../lib/init.vim)
          ] else [
            "let s:lsp_support = 0"
            (lib.strings.fileContents ../lib/init.vim)
          ];
      in
      builtins.concatStringsSep "\n" (with pkgs;
      [
        # nvim-treesitter requires gcc and tree-sitter to be in the path as seen by neovim
        "call setenv('PATH', '${gcc}/bin:${tree-sitter}/bin:' . getenv('PATH'))"
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
            (pkgs.callPackage ../pkgs/stylua { })
            jdtls

            ccls # c++ language server
            delve
            gopls
            jsonnet-language-server
            nixfmt
            python-language-server
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
            nodePackages.fixjson
            nodePackages.markdownlint-cli
            nodePackages.neovim
            nodePackages.prettier
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
        gcc
        libcxx
        tree-sitter
        # end required by tree-sitter

        gnutar
      ] ++ lspPackages;
  };
}

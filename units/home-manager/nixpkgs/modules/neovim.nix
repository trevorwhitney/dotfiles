{ config, pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = builtins.concatStringsSep "\n" (with pkgs; [
      # nvim-treesitter requires gcc and tree-sitter to be in the path as seen by neovim
      "call setenv('PATH', '${gcc}/bin:${tree-sitter}/bin:' . getenv('PATH'))"
      # set path the lua language server so we can pass it to respective lsp config
      "let s:sumneko_lua_ls_path = '${sumneko-lua-language-server}'"
      "let s:rocks_tree_root = '${lua51Packages.luarocks}'"
      (lib.strings.fileContents ../lib/init.vim)
    ]);

    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    extraPython3Packages = (ps:
      with ps; [
        pynvim
      ]);

    # Will use packer to grab everything else
    plugins = with pkgs.vimPlugins; [ packer-nvim ];

    extraPackages = (with pkgs; [
      # required by tree-sitter
      gcc
      libcxx
      tree-sitter
      # end required by tree-sitter

      #TODO: move to programs.git
      git

      gnutar
      gopls
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
    ]);

  };
}

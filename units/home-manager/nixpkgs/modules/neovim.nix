{ config, pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = builtins.concatStringsSep "\n" [
      # nvim-treesitter requires gcc and tree-sitter to be in the path as seen by neovim
      "call setenv('PATH', '${pkgs.gcc}/bin:${pkgs.tree-sitter}/bin:' . getenv('PATH'))"
      # set path the lua language server so we can pass it to respective lsp config
      "let s:sumneko_lua_ls_path = '${pkgs.sumneko-lua-language-server}'"
      (lib.strings.fileContents ../lib/init.vim)
    ];

    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    extraPython3Packages =
      (ps: with ps; [ "python-language-server" "pynvim" "vim-vint" ]);

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
      python39
      rnix-lsp
      shellcheck
      shfmt
      terraform-ls
      vale
      yamllint

      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.fixjson
      nodePackages.neovim
      nodePackages.prettier
      nodePackages.vim-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.write-good
      nodePackages.yaml-language-server
    ]);

  };
}

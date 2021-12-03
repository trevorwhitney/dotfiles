{ config, pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = builtins.concatStringsSep "\n" [
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
      curl
      git
      gnutar
      gopls
      kotlin
      nixfmt
      nodejs
      python39
      rnix-lsp
      shellcheck
      shfmt
      terraform
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

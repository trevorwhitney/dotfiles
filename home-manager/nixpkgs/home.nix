{ config, pkgs, lib, ... }:

let
  tw-vim-lib = pkgs.vimUtils.buildVimPlugin {
    name = "tw-vim-lib";
    src = pkgs.fetchFromGitHub {
      owner = "trevorwhitney";
      repo = "tw-vim-lib";
      rev = "main";
      sha256 = "04a9fvxa7hrjmwzp6rkrhbv2kvf6dd0b6nnk7haxj0c9iyp69arf";
    };
  };
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "twhitney";
  home.homeDirectory = "/home/twhitney";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  # these are packages I need on the command line as well
  # TODO: move lua-language-server to neovim extra package
  # and refactor config to take base sumneko path
  # TODO: install stylua via luarocks
  home.packages = with pkgs; [
    sumneko-lua-language-server
    golangci-lint
    lua53Packages.luarocks
  ];

  #TODO: lua53packages.luarocks
  #TODO: add luarocks and stylua

  # Some tree-sitter grammars have trouble compiling with home-manager, so we copy in their
  # pre-compiled parsers directly
  xdg.dataFile."nvim/site/parser/bash.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
  xdg.dataFile."nvim/site/parser/lua.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  xdg.dataFile."nvim/site/parser/yaml.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-yaml}/parser";
  # The following parsers seems to be working fine using the navite TSInstall/Update commands, but
  # I'm keeping references to the pre-compiled parsers in case they ever break
  # xdg.dataFile."nvim/site/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
  # xdg.dataFile."nvim/site/parser/css.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-css}/parser";
  # xdg.dataFile."nvim/site/parser/go.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-go}/parser";
  # xdg.dataFile."nvim/site/parser/java.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-java}/parser";
  # xdg.dataFile."nvim/site/parser/javascript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-javascript}/parser";
  # xdg.dataFile."nvim/site/parser/json.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-json}/parser";
  # xdg.dataFile."nvim/site/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
  # xdg.dataFile."nvim/site/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
  # xdg.dataFile."nvim/site/parser/toml.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-toml}/parser";
  # xdg.dataFile."nvim/site/parser/typescript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-typescript}/parser";
  # xdg.dataFile."nvim/site/parser/vim.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-vim}/parser";

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = builtins.concatStringsSep "\n" [
      "let s:sumneko_lua_ls_path = '${pkgs.sumneko-lua-language-server}'"
      (lib.strings.fileContents ./init.vim)
    ];

    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    extraPython3Packages =
      (ps: with ps; [ "python-language-server" "pynvim" "vim-vint" ]);

    plugins = with pkgs.vimPlugins; [ packer-nvim tw-vim-lib ];

    extraPackages = (with pkgs; [
      curl
      gcc # required by tree-sitter
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
      tree-sitter
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

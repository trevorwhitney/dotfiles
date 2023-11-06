{ pkgs
, lib
, fetchFromGitHub
, vimUtils
, neovimUtils
, withLspSupport ? true
, nodeJsPkg ? pkgs.nodejs
, goPkg ? pkgs.go
, useEslintDaemon ? true
, extraPackages ? [ ]
, ...
}:
let
  basePackages = with pkgs; [
    nodeJsPkg
    goPkg

    gcc
    gnumake
    gnutar

    nodePackages.markdownlint-cli
    nil
    nixpkgs-fmt
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

  treesitterPackages = with pkgs; [
    stdenv.cc
    tree-sitter
  ];

  packages = basePackages ++ treesitterPackages ++ lspPackages ++ extraPackages;

  extraMakeWrapperArgs = lib.optionalString (packages != [ ])
    ''--suffix PATH : "${lib.makeBinPath packages}"'';

  neovimConfig = neovimUtils.makeNeovimConfig
    {
      vimAlias = true;
      withRuby = true;
      withPython3 = true;

      # manually overriden in package
      withNodeJs = false;

      extraPython3Packages = ps: with ps; [ pynvim ];
      plugins = with pkgs.vimPlugins; [
        packer-nvim
        (vimUtils.buildVimPlugin rec {
          pname = "tw-vim-lib";
          version = "28cfb4b14f4b4aa928b00c5d5efd9236cf9080c5";
          # src = fetchFromGitHub {
          #   owner = "trevorwhitney";
          #   repo = "tw-vim-lib";
          #   rev = version;
          #   # sha256 = lib.fakeSha256;
          #   sha256 = "cMNP6M6WHW1VoKBDws8+G+aGXlHRfuYb4b6KIwCkmCc=";
          # };
          # uncomment for testing local changes, make sure to rebuild with --impure
          src = /home/twhitney/workspace/tw-vim-lib;
          meta.homepage = "https://github.com/trevorwhitney/tw-vim-lib";
        })
      ];

      customRC = builtins.concatStringsSep "\n" (with pkgs; [
        "lua <<EOF"
        "require('tw.config').setup({"
      ] ++ (if withLspSupport then [
        "lsp_support = true,"
        "lua_ls_root = '${lua-language-server}',"
        "rocks_tree_root = '${lua51Packages.luarocks}',"
        "jdtls_home = '${jdtls}',"
        "use_eslint_daemon = ${lib.boolToString useEslintDaemon},"
      ] else [
        "lsp_support = false,"
      ]) ++ [
        "extra_path = {'${stdenv.cc}/bin', '${tree-sitter}/bin'},"
        "})"
        "EOF"
      ]);
    };
in
with pkgs; (wrapNeovimUnstable
  (neovim-unwrapped.override { nodejs = nodeJsPkg; })
  (neovimConfig // {
    wrapperArgs =
      (lib.escapeShellArgs neovimConfig.wrapperArgs) + " "
        + extraMakeWrapperArgs;
    # TODO: do I need any of these other wrapper args from the original?
    # wrapperArgs =
    #   (lib.escapeShellArgs neovimConfig.wrapperArgs) + " "
    #     + extraMakeWrapperArgs + " " + extraMakeWrapperLuaCArgs + " "
    #     + extraMakeWrapperLuaArgs;
  }))

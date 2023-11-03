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
          version = "e882184993bd1d457ce2a27fe45e192878067e6c";
          src = fetchFromGitHub {
            owner = "trevorwhitney";
            repo = "tw-vim-lib";
            rev = version;
            sha256 = "ced5VJnJVI15npFzLjkMgNc7QEw4laGBUYeNhciiRWE=";
          };
          # uncomment for testing local changes, make sure to rebuild with --impure
          # src = /home/twhitney/workspace/tw-vim-lib;
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

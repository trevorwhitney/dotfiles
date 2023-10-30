{ pkgs
, lib
, fetchFromGitHub
, vimUtils
, neovimUtils
, withLspSupport ? true
, extraPackages ? [ ]
, ...
}:
let
  nodeJsPkg = pkgs.nodejs_18;

  basePackages = with pkgs; [
    gcc
    gnumake
    nodeJsPkg
    nodePackages.markdownlint-cli
    # 3 options for nix LSP, nil currently working best
    # rnix-lsp
    # nixd
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

  packages = with pkgs; [
    # required by tree-sitter
    stdenv.cc
    tree-sitter
    # end required by tree-sitter

    gnutar
  ] ++ basePackages ++ lspPackages ++ extraPackages;

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
          version = "637a21465a3e58d885285bc043cf309732bff071";
          src = fetchFromGitHub {
            owner = "trevorwhitney";
            repo = "tw-vim-lib";
            rev = version;
            sha256 = "F3itwKcbTvUhDidAVsCJYD4qxSvYjhAIH82F0BdkRK4=";
          };
          # uncomment for testing local changes, make sure to rebuild with --impure
          # src = /home/twhitney/.local/share/nvim/site/pack/packer/start/tw-vim-lib;
          meta.homepage = "https://github.com/trevorwhitney/tw-vim-lib";
        })
      ];

      customRC = builtins.concatStringsSep "\n" (with pkgs; [
        "lua <<EOF"
        "require('tw.config').setup({"
      ] ++ (if withLspSupport then [
        "lsp_support = true,"
        "lua_ls_path = '${lua-language-server}',"
        "rocks_tree_root = '${lua51Packages.luarocks}',"
        "jdtls_home = '${jdtls}',"
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

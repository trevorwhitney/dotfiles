{ self, pkgs, ... }:

# 1. nix build .#nvim-container
# 2. docker load < result
# 3. docker volume create nvim
# 4. docker run -v $(pwd):/src -v nvim:/etc/xdg -it twhitney/nvim:70h4bfwbi3v2wq31ykz0mkjqliwfbqwd nvim flake.nix
pkgs.dockerTools.buildImage {
  name = "twhitney/nvim";
  copyToRoot = pkgs.buildEnv
    {
      name = "base";
      paths = with pkgs; [
        # for system
        bash
        coreutils
        git
        pkgs.nix
        zsh

        # for neovim
        gcc
        gnumake
        nodejs_18
        nodePackages.markdownlint-cli
        nil
        nixpkgs-fmt
        statix
        stylua
        jdtls

        gawk
        ccls # c++ language server
        delve
        gopls
        go_1_21
        gotools
        golangci-lint
        jsonnet-language-server
        lua-language-server
        pyright
        shellcheck
        shfmt
        terraform-ls
        terraform
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

        # required by tree-sitter
        stdenv.cc
        tree-sitter
        # end required by tree-sitter

        gnutar

        (wrapNeovimUnstable neovim-unwrapped (neovimUtils.makeNeovimConfig {
          vimAlias = true;
          withRuby = true;
          withPython3 = true;
          withNodeJs = false;

          extraPython3Packages = ps: with ps; [ pynvim ];
          plugins = with pkgs.vimPlugins; [
            packer-nvim
            (pkgs.vimUtils.buildVimPlugin rec {
              pname = "tw-vim-lib";
              version = "ab4892d0f33e68c4970befb7a35a2c69a0a7bcff";
              src = fetchFromGitHub {
                owner = "trevorwhitney";
                repo = "tw-vim-lib";
                rev = version;
                sha256 = "8xK+3DzfFCDQzk+ZmqL9EN7Mvkn2MTy6VsRsW4cLBJM=";
              };
              meta.homepage = "https://github.com/trevorwhitney/tw-vim-lib";
            })
          ];
          customRC = builtins.concatStringsSep "\n" (with pkgs;
            [
              # nvim-treesitter requires gcc and tree-sitter to be in the path as seen by neovim
              "call setenv('PATH', '${stdenv.cc}/bin:${tree-sitter}/bin:' . getenv('PATH'))"
              "let s:lsp_support = 1"
              "let s:lua_ls_path = '${lua-language-server}'"
              "let s:rocks_tree_root = '${lua51Packages.luarocks}'"
              "let g:jdtls_home = '${jdtls}'"
              (lib.strings.fileContents "${self}/nix/home-manager/modules/lib/init.vim")
            ]);
        }))

        (pkgs.stdenv.mkDerivation {
          name = "xdg-home";
          src = ./.;
          installPhase = ''
            mkdir -p $out/etc/xdg/config $out/etc/xdg/share $out/etc/xdg/state
          '';
        })
      ];

      pathsToLink = [ "/bin" "/etc" "/share" ];
    };
  config = {
    Env = [
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "XDG_CONFIG_HOME=/etc/xdg/config"
      "XDG_DATA_HOME=/etc/xdg/share"
      "XDG_STATE_HOME=/etc/xdg/state"
      "COLORTERM=truecolor"
      "TERM=screen-256color"
    ];
    WorkingDir = "/src";
  };
}

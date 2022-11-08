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
      _cc = "${pkgs.stdenv.cc}";

    in
    rec {
      # always start vim in a tmux pane
      home.file.".local/bin/vim".text = ''
        #!${pkgs.bash}/bin/bash
        mkdir -p "''${HOME}/.cache/nvim"

        current_dir="''$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
        working_dir="''$(pwd)"

        file="''${@}"
        if [[ ''$# -eq 1 ]]; then
          case ''$file in
            /*) ;;
            *) file="''${working_dir}/''${file}" ;;
          esac
        fi

        if [[ ! -z "''$file" ]]; then
          dir="''$(dirname ''$file)"
          if [[ -d "''$file" ]]; then
            dir="''$file"
          fi
          pushd ''$dir > /dev/null
          current_dir="''$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
          popd > /dev/null
        fi

        dir_name="''$(basename ''${current_dir})"
        if [[ -z "''${TMUX}" ]]; then
          session_name="vim ''${dir_name}"
          session_socket="''${HOME}/.cache/nvim/''${dir_name}.pipe"

          if tmux ls &> /dev/null && tmux has-session -t "''${session_name}"; then
            if [[ $# -ne 0 ]]; then
              ${finalPackage}/bin/nvim --server "''${session_socket}" --remote ''$file
            fi
            tmux attach -t "''${session_name}"
          else
            if [[ -e "''${session_socket}" ]]; then
              ${finalPackage}/bin/nvim --server "''${session_socket}" --remote-send "<Esc>:qa!<cr>"
              rm -f ''${session_socket}
            fi

            tmux new-session -s "''${session_name}" -n "''${dir_name}" ${finalPackage}/bin/nvim --listen "''${session_socket}" ''$file
          fi
        else
          ${finalPackage}/bin/nvim --listen "''${session_socket}" ''$file
        fi
      '';
      home.file.".local/bin/vim".executable = true;

      xdg.dataFile."jdtls/config_linux/config.ini" =
        lib.mkIf withLspSupport { source = "${jdtls}/config_linux/config.ini"; };
      programs.neovim = {
        enable = true;

        # manually provide node to pin @ version that works with Copilot
        withNodeJs = false;
        package = pkgs.neovim-unwrapped.override {
          nodejs = pkgs.nodejs-16_x;
        };
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
                "let s:lsp_support = 1"
                (lib.strings.fileContents ./lib/init.vim)
              ];
          in
          builtins.concatStringsSep "\n" (with pkgs;
          [
            # nvim-treesitter requires gcc and tree-sitter to be in the path as seen by neovim
            "call setenv('PATH', '${_cc}/bin:${tree-sitter}/bin:' . getenv('PATH'))"
          ] ++ exCfg);

        withRuby = true;
        withPython3 = true;
        extraPython3Packages = ps: with ps; [ pynvim ];

        # Will use packer to grab everything else
        plugins = with pkgs.vimPlugins; [ packer-nvim ];

        extraPackages =
          let
            basePackages = with pkgs; [
              rnix-lsp
              statix
              nodejs-16_x
            ];
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
                shellcheck
                shfmt
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
              ] else [ ];
          in
          with pkgs;
          [
            # required by tree-sitter
            _cc
            tree-sitter
            # end required by tree-sitter

            gnutar
          ] ++ basePackages ++ lspPackages;
      };
    };
}

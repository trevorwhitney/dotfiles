{ self, pkgs, ... }:

# 1. nix build .#nvim-container
# 2. docker load < result
# 3. docker tag sha latest
# 3. docker volume create nvim-data
# 4. docker volume create nvim-tmp
# 4. docker volume create nvim-nix
# gopls needs a /tmp directory
# 4. nvim-container flake.nix
# TODO:
#   - forward ssh agent into docker container, something like? -v $(readlink -f $SSH_AUTH_SOCK):/var/run/sshd/agent.sock
#       - tried this, currently not working
#   - figure out clipboard sharing
let
  nvim = with pkgs; (wrapNeovimUnstable neovim-unwrapped (neovimUtils.makeNeovimConfig {
    vimAlias = true;
    withRuby = true;
    withPython3 = true;
    withNodeJs = false;

    extraPython3Packages = ps: with ps; [ pynvim ];
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "tw-vim-lib";
        version = "b36bcf422e3945105ab37af315ac2311848efeba";
        src = fetchFromGitHub {
          owner = "trevorwhitney";
          repo = "tw-vim-lib";
          rev = version;
          sha256 = "8xK+3DzfFCDQzk+ZmqL9EN7Mvkn2MTy6VsRsW4cLBJM=";
        };
        meta.homepage = "https://github.com/trevorwhitney/tw-vim-lib";
      })
    ];
    customRC = builtins.concatStringsSep "\n" [
      # nvim-treesitter requires gcc and tree-sitter to be in the path as seen by neovim
      "call setenv('PATH', '${stdenv.cc}/bin:${tree-sitter}/bin:' . getenv('PATH'))"
      "let s:lsp_support = 1"
      "let s:lua_ls_path = '${lua-language-server}'"
      "let s:rocks_tree_root = '${lua51Packages.luarocks}'"
      "let g:jdtls_home = '${jdtls}'"
      (lib.strings.fileContents "${self}/nix/home-manager/modules/lib/init.vim")
    ];
  }));

  nixConf = pkgs.writeText "nix.conf" ''
    allowed-users = *
    auto-optimise-store = false
    cores = 0
    max-jobs = auto
    require-sigs = true
    sandbox = true
    sandbox-fallback = false
    substituters = https://cache.nixos.org/
    system-features = nixos-test benchmark big-parallel kvm
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
    experimental-features = nix-command flakes
  '';

  gitconfig = pkgs.lib.generators.toGitINI {
    core = {
      editor = "nvim";
      excludesfile = "~/.config/git/ignore";
    };
    apply = { whitespace = "nowarn"; };
    color = {
      branch = "auto";
      diff = "auto";
      interactive = "auto";
      status = "auto";
      ui = "auto";
    };
    branch = { autosetupmerge = true; };
    rebase = { autosquash = true; };
    push = { default = "simple"; };
    merge = { tool = "vimdiff"; };
    diff = { tool = "vimdiff"; };
    mergetool = { keepBackup = false; };
    init = {
      templatedir = "${pkgs.git-template}";
      defaultBranch = "main";
    };

    credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";

    safe.directory = "/src";
  };

  xdg-home = pkgs.stdenv.mkDerivation rec {
    name = "xdg-home";
    src = ./.;

    etcGitconfig = pkgs.writeText "gitconfig" gitconfig;

    installPhase = ''
      mkdir -p $out/var/run/sshd
      mkdir -p $out/etc/nix $out/etc/xdg/config $out/etc/xdg/share $out/etc/xdg/state
      cp "${etcGitconfig}" $out/etc/gitconfig
      cp "${nixConf}" $out/etc/nix/nix.conf
    '';
  };

  paths = [
    nvim
    xdg-home
  ] ++ (with pkgs; [
    # required by tree-sitter
    stdenv.cc
    tree-sitter
    # end required by tree-sitter

    bash
    ccls # c++ language server
    coreutils
    delve
    gawk
    git
    gnumake
    gnutar
    go_1_21
    golangci-lint
    gopls
    gotools
    jdtls
    jsonnet-language-server
    lua-language-server
    nil
    nixpkgs-fmt
    nodePackages.markdownlint-cli
    nodejs_18
    openssh
    pkgs.nix
    pyright
    shellcheck
    shfmt
    statix
    stylua
    terraform
    terraform-ls
    tmux
    vale
    vim-vint
    yamllint
    zsh

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
  ]);
in
pkgs.dockerTools.buildImage {
  name = "twhitney/nvim";
  copyToRoot = pkgs.buildEnv
    {
      inherit paths;
      name = "base";
      pathsToLink = [ "/bin" "/etc" "/share" "/var" ];
    };

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    ${pkgs.dockerTools.shadowSetup}
    groupadd -r nvim
    useradd -rm -g nvim nvim
    chown -R nvim:nvim /bin /etc /share /var
    chmod -R 775 /etc
  '';

  config = {
    Env = [
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "XDG_CONFIG_HOME=/etc/xdg/config"
      "XDG_DATA_HOME=/etc/xdg/share"
      "XDG_STATE_HOME=/etc/xdg/state"
      "COLORTERM=truecolor"
      "TERM=screen-256color"
      # TODO: this isn't working. ssh not using agent in container?
      "SSH_AUTH_SOCK=/var/run/sshd/agent.sock"
    ];
    WorkingDir = "/src";
    User = "nvim:nvim";
  };
}

{ pkgs, ... }:
let
  inherit (pkgs) dotfiles;
in
{
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    java = {
      enable = true;
      package = pkgs.jdk11;
    };

    direnv = {
      enable = true;
      nix-direnv = { enable = true; };
    };
    zsh = {
      shellAliases = {
        brew = "/opt/homebrew/bin/brew ";
      };
      useBrew = true;
      startNixDaemon = true;
    };
  };

  home = {
    file = {
      ".ctags".source = "${dotfiles}/ctags";
      ".dircolors".source = "${dotfiles}/dircolors";
      ".git-authors".source = "${dotfiles}/git-authors";
      ".prettierrc".source = "${dotfiles}/prettierrc.json";
      ".markdownlint.json".source = "${dotfiles}/markdownlint.json";
      ".todo/config".source = "${dotfiles}/todo.cfg";
      ".ideavimrc".source = "${dotfiles}/ideavimrc";
      ".gnupg/gpg.conf".text = ''
        default-key  78F930867F302694

        keyserver  hkp://pool.sks-keyservers.net
        use-agent
      '';
    };

    packages = with pkgs; [
      awscli2
      azure-cli
      bat
      bind
      cmake
      coreutils
      curl
      diffutils
      fd
      fzf
      gnused
      gnumake
      go
      (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        beta
        alpha
        gke-gcloud-auth-plugin
      ]))
      jq
      k9s
      lsof
      lua51Packages.luarocks
      luajit
      mosh
      ncurses
      ngrok
      nmap
      rbenv
      ripgrep
      unixtools.watch
      virtualenv
      yarn
      yq
    ];
  };

  # Currently broken: https://github.com/NixOS/nixpkgs/issues/196651
  #manual.manpages.enable = false;
}

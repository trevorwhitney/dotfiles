{ pkgs, ... }:
let
  inherit (pkgs) dotfiles;
in
{
  programs = {
    java = {
      enable = true;
      package = pkgs.jdk11;
    };

    zsh = {
      shellAliases = {
        brew = "/opt/homebrew/bin/brew ";
        rebuild = "sudo darwin-rebuild switch --flake $HOME/workspace/dotfiles ";
      };
      useBrew = true;
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
      bat
      bind
      cmake
      coreutils
      curl
      diffutils
      dotfiles
      fd
      fzf
      gnused
      gnumake
      jq
      k9s
      lsof
      lua51Packages.luarocks
      luajit
      mosh
      ncurses
      ngrok
      nixd
      nmap
      rbenv
      ripgrep
      unixtools.watch
      virtualenv
      yarn
      yq-go
    ];
  };
}

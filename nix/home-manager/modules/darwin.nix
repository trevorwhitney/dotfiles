{ config, pkgs, ... }:
let
  inherit (pkgs) dotfiles;
  dotfilesPath = "${config.home.homeDirectory}/workspace/dotfiles/dotfiles";
  configHome = config.xdg.configHome;
in
{
  imports = [ ./live-links.nix ];

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk11;
    };

    zsh = {
      shellAliases = {
        brew = "/opt/homebrew/bin/brew ";
        rebuild = "sudo darwin-rebuild switch --flake $HOME/workspace/dotfiles/dotfiles ";
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
      rclone
      ripgrep
      unixtools.watch
      virtualenv
      yq-go
    ];
  };

  # macOS has no systemd/pam to provide XDG_RUNTIME_DIR.
  home.sessionVariables = {
    XDG_RUNTIME_DIR = "${config.home.homeDirectory}/.local/runtime";
  };

  dotfiles.liveLinks = {
    "${configHome}/workmux/config.yaml" = "${dotfilesPath}/workmux/config.yaml";
    "${configHome}/workmux/branch-name.sh" = "${dotfilesPath}/workmux/branch-name.sh";
    "${configHome}/sandbox-exec/agent.sb" = "${dotfilesPath}/sandbox-exec/agent.sb";
    "${configHome}/sandbox-exec/run-sandboxed.sh" = "${dotfilesPath}/sandbox-exec/run-sandboxed.sh";
  };
}

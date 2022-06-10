{ config, pkgs, lib, ... }:
let dotfiles = pkgs.callPackage ../pkgs/dotfiles { };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home.sessionVariables = { EDITOR = "vim"; };

  home.file.".ctags".source = "${dotfiles}/ctags";
  home.file.".dircolors".source = "${dotfiles}/dircolors";
  home.file.".git-authors".source = "${dotfiles}/git-authors";
  home.file.".prettierrc".source = "${dotfiles}/prettierrc.json";
  home.file.".markdownlint.json".source = "${dotfiles}/markdownlint.json";
  home.file.".todo/config".source = "${dotfiles}/todo.cfg";
  xdg.configFile."yamllint/config".source =
    "${dotfiles}/yamllint.yaml";
  xdg.configFile."k9s/skin.yml".source =
    "${dotfiles}/config/k9s/solarized_light.yml";
  xdg.configFile."tridactyl/tridactylrc".source =
    "${dotfiles}/config/tridactyl/tridactylrc";

  # TODO: copy google cloud sdk completion
  # ln -sf /usr/share/google-cloud-sdk/completion.zsh.inc "$HOME/.oh-my-zsh/custom/gcloud-completion.zsh"
  # ~/.nix-profile/google-cloud-sdk/completion.zsh.inc

  home.packages = with pkgs; [
    /* (pkgs.callPackage ../pkgs/goimports { }) */
    /* (pkgs.callPackage ../pkgs/gocomplete { }) */
    /* (pkgs.callPackage ../pkgs/jsonnet { }) */
    /* (pkgs.callPackage ../pkgs/jsonnet-lint { }) */
    /* (pkgs.callPackage ../pkgs/jsonnetfmt { }) */
    /* (pkgs.callPackage ../pkgs/protoc-gen-gogofast { }) */
    /* (pkgs.callPackage ../pkgs/protoc-gen-gogoslick { }) */
    /* (pkgs.callPackage ../pkgs/kns-ktx { }) */
    /* (pkgs.callPackage ../pkgs/xk6 { }) */

    awscli2
    azure-cli
    bash
    bat
    cargo
    chart-testing
    cmake
    curl
    delta
    docker
    docker-compose
    drone-cli
    fzf
    gh
    glow
    gnused
    go_1_17
    golangci-lint
    google-cloud-sdk
    gradle
    helm-docs
    jsonnet-bundler
    jq
    k9s
    kotlin
    kube3d
    kubectl
    kubernetes-helm
    lm_sensors
    lua51Packages.luarocks
    luajit
    lynis
    mosh
    ncurses
    nodejs
    python38
    rbenv
    ripgrep
    ruby
    rustc
    sysstat
    tanka
    terraform
    todo-txt-cli
    tz
    vault
    virtualenv
    xsel
    yamale
    yarn
  ];

  #TODO: lua53packages.luarocks
  #TODO: add luarocks and stylua

  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };

  # enabling bash makes sure ~/.profile is setup correctly
  # which some other things rely on
  programs.direnv = {
    enable = true;
    nix-direnv = { enable = true; };
  };
}

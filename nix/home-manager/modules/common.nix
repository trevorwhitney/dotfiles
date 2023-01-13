{ config, pkgs, lib, ... }:
let inherit (pkgs) dotfiles;
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.file.".ctags".source = "${dotfiles}/ctags";
  home.file.".dircolors".source = "${dotfiles}/dircolors";
  home.file.".git-authors".source = "${dotfiles}/git-authors";
  home.file.".prettierrc".source = "${dotfiles}/prettierrc.json";
  home.file.".markdownlint.json".source = "${dotfiles}/markdownlint.json";
  home.file.".todo/config".source = "${dotfiles}/todo.cfg";

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source =
    "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  xdg.configFile."yamllint/config".source = "${dotfiles}/yamllint.yaml";
  xdg.configFile."k9s/skin.yml".source =
    "${dotfiles}/config/k9s/solarized_light.yml";

  home.file.".tridactylrc".source = "${dotfiles}/config/tridactyl/tridactylrc";

  # TODO: copy google cloud sdk completion
  # ln -sf /usr/share/google-cloud-sdk/completion.zsh.inc "$HOME/.oh-my-zsh/custom/gcloud-completion.zsh"
  # ~/.nix-profile/google-cloud-sdk/completion.zsh.inc

  # Currently broken: https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = false;

  home.packages = with pkgs; [
    gocomplete
    jsonnet
    jsonnet-lint
    protoc-gen-gogofast
    protoc-gen-gogoslick
    kns-ktx
    xk6

    _1password
    awscli2
    azure-cli
    bashInteractive
    bat
    bind
    cargo
    chart-testing
    cmake
    curl
    delta
    diffutils
    docker
    docker-compose
    drone-cli
    fzf
    glow
    gnused
    go
    golangci-lint
    (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
      beta
      alpha
      gke-gcloud-auth-plugin
    ]))
    gradle
    helm-docs
    home-manager
    jsonnet-bundler
    jq
    k9s
    kotlin
    kube3d
    kubernetes-helm
    lm_sensors
    lua51Packages.luarocks
    luajit
    lynis
    mosh
    ncurses
    ngrok
    rbenv
    ripgrep
    rustc
    sysstat
    tanka
    terraform
    tmate
    todo-txt-cli
    tridactyl-native
    tz
    vault
    virtualenv
    xsel
    yamale
    yarn
  ];

  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = { enable = true; };
  };
}

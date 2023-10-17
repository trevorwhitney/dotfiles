{ config, pkgs, lib, ... }:
let inherit (pkgs) dotfiles;
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home.file.".ctags".source = "${dotfiles}/ctags";
  home.file.".dircolors".source = "${dotfiles}/dircolors";
  home.file.".git-authors".source = "${dotfiles}/git-authors";
  home.file.".prettierrc".source = "${dotfiles}/prettierrc.json";
  home.file.".markdownlint.json".source = "${dotfiles}/markdownlint.json";
  home.file.".todo/config".source = "${dotfiles}/todo.cfg";
  home.file.".ideavimrc".source = "${dotfiles}/ideavimrc";
  home.file.".gnupg/gpg.conf".text = ''
    default-key  78F930867F302694

    keyserver  hkp://pool.sks-keyservers.net
    use-agent
  '';

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source =
    "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  xdg.configFile."yamllint/config".source = "${dotfiles}/yamllint.yaml";

  home.file.".tridactylrc".source = "${dotfiles}/config/tridactyl/tridactylrc";

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

    awscli2
    azure-cli
    bashInteractive
    bat
    bind
    chart-testing
    cmake
    curl
    delta
    diffutils
    docker
    docker-compose
    drone-cli
    fd
    file
    fzf
    glow
    gnused
    gnumake
    go
    (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
      beta
      alpha
      gke-gcloud-auth-plugin
    ]))
    gradle
    guardian-agent
    helm-docs
    jetbrains.idea-community
    jsonnet-bundler
    jq
    kotlin
    kube3d
    kubernetes-helm
    lm_sensors
    lsof
    lua51Packages.luarocks
    luajit
    lynis
    mktemp
    mosh
    ngrok
    ncurses
    nmap
    rbenv
    ripgrep
    # rust-bin.stable.latest.default # to bring in rustc, but not sure if it's needed in common
    sysstat
    tanka
    terraform
    tmate
    todo-txt-cli
    tridactyl-native
    tz
    vault
    virtualenv

    # TODO: can we have both, should there be guard for X11 vs wayland?
    xsel
    wl-clipboard

    yamale
    yarn
    yq
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

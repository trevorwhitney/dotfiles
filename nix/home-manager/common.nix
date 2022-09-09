{ config, pkgs, lib, ... }:
let inherit (pkgs) dotfiles;
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg = {
    enable = true;

    mimeApps = {
      enable = true;
      associations = {
        added = {
          #TODO: replace with kitty-open?
          "application/octet-stream" = "gvim.desktop";
          "application/text" = "kitty-open.desktop;gvim.desktop;vim.desktop";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";

          "audio/mpeg" = "org.audacityteam.Audacity.desktop;";

          "image/jpeg" = "org.gimp.GIMP.desktop;display-im6.q16.desktop";
          #TODO: how do I get annotator?
          "image/png" = "com.github.phase1geo.annotator.desktop;firefox.desktop;org.gimp.GIMP.desktop";

          "text/html" = "firefox.desktop";
          "text/plain" = "kitty-open.desktop;nvim.desktop;gvim.desktop";

          "video/x-matroska" = "vlc_vlc.desktop;";

          "x-scheme-handler/chrome" = "google-chrome.desktop";
          "x-scheme-handler/ftp" = "firefox.desktop;";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
        };
        removed = {
          "x-scheme-handler/chrome" = "firefox.desktop";
        };
      };
      defaultApplications = {
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";

        "text/calendar" = "org.gnome.Calendar.desktop";
        "text/html" = "firefox.desktop";
        "text/plain" = "kitty-open.desktop";

        "video/x-matroska" = "vlc_vlc.desktop";

        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/chrome" = "google-chrome.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
        "x-scheme-handler/webcal" = "google-chrome.desktop";
      };
    };
  };

  targets.genericLinux.enable = true;

  home.sessionVariables = { EDITOR = "vim"; };

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

  home.packages = with pkgs; [
    gotools
    jsonnet
    jsonnet-lint
    protoc-gen-gogofast
    protoc-gen-gogoslick
    kns-ktx
    xk6

    _1password
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
    ngrok
    nodejs
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

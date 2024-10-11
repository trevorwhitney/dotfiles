{ pkgs, lib, config, ... }: {
  homebrew = {
    enable = true;
    onActivation = {
     autoUpdate = true;
     cleanup = "zap";
     upgrade = true;
    };
    brews = [
      "pam-reattach"
      "usbutils"
      "reattach-to-user-namespace"
      "mas"
    ];

    casks = [
      "discord"
      "deadbeef@nightly"
      "flux"
      "iterm2"
      "plexamp"
      "raycast"
      "tailscale"
      "vimr"
      "vlc"
    ];

    masApps = {
      Xcode = 497799835;
    };
  };
}

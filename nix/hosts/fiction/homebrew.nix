{ pkgs, lib, config, ... }: {
  homebrew = {
    enable = true;
    brews = [
      "pam-reattach"
      "usbutils"
      "reattach-to-user-namespace"
      "mas"
    ];

    casks = [
      "discord"
      "chatgpt"
      "deadbeef@nightly"
      "flux"
      "iterm2"
      "kitty"
      "plexamp"
      "qutebrowser"
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

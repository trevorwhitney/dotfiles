{ pkgs, lib, config, ... }: {
  homebrew = {
    enable = true;
    onActivation = {
     autoUpdate = true;
     cleanup = "zap";
     upgrade = true;
    };

    brews = [
      "mas"
      "pam-reattach"
      "reattach-to-user-namespace"
      "telnet"
      "usbutils"
      "python"
      "pipx" # for aider
    ];

    casks = [
      "discord"
      "deadbeef@nightly"
      "dotnet-sdk"
      "flux"
      "ghostty"
      "iterm2"
      "plexamp"
      "raycast"
      "tailscale"
      "vimr"
      "vlc"
      "wireshark"
    ];

    masApps = {
      Xcode = 497799835;
    };
  };
}

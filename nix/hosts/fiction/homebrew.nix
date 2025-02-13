{ pkgs, lib, config, ... }: {
  homebrew = {
    enable = true;
    onActivation = {
     autoUpdate = true;
     cleanup = "zap";
     upgrade = true;
    };

    brews = [
      # "aider"
      "mas"
      "pam-reattach"
      "reattach-to-user-namespace"
      "telnet"
      "usbutils"
    ];

    casks = [
      "discord"
      "deadbeef@nightly"
      "dotnet-sdk"
      "flux"
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

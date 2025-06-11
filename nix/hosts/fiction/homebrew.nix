{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
     autoUpdate = true;
     cleanup = "zap";
     upgrade = true;
    };

    brews = [
      "fswatch"
      "k6"
      "mas"
      "pipx" # for aider
      "python"
      "reattach-to-user-namespace"
      "telnet"
      "trufflehog"
      "usbutils"
      "xk6"
      "zizmor"
    ];

    casks = [
      "discord"
      "deadbeef@nightly"
      "dotnet-sdk"
      "flux"
      "ghostty"
      "iterm2"
      "mullvad-browser"
      "mullvad-vpn"
      "plexamp"
      "raycast"
      "tailscale"
      "vimr"
      "vlc"
      "warp"
      "wine-stable"
      "wireshark"
    ];
  };
}

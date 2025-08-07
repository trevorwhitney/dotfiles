{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
     autoUpdate = true;
     cleanup = "zap";
     upgrade = true;
    };

    brews = [
      "awscli"
      "bfg"
      "fswatch"
      "k6"
      "mas"
      "pipx" # for aider
      "python"
      "reattach-to-user-namespace"
      "telnet"
      "trufflehog"
      "usbutils"
      "uv"
      "xk6"
      "zizmor"
    ];

    casks = [
      "beekeeper-studio"
      "discord"
      "deadbeef@nightly"
      "dotnet-sdk"
      "brave-browser@beta"
      "flux-app"
      "ghostty"
      "iterm2"
      "mullvad-browser"
      "mullvad-vpn"
      "orbstack"
      "plexamp"
      "raycast"
      "spotify"
      "tailscale-app"
      "todoist-app"
      "vimr"
      "vlc"
      "warp"
      "wine-stable"
      "wireshark-app"
    ];
  };
}

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
      "goose"
      "gnu-sed"
      "k6"
      "mas"
      "pipx" # for aider
      "python"
      "reattach-to-user-namespace"
      "telnet"
      "tree"
      "trufflehog"
      "usbutils"
      "uv"
      "xk6"
      "zizmor"
    ];

    casks = [
      "1password-cli"
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
      "pocket-casts"
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

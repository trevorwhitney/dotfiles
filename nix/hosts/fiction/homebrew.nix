{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "eugene1g/safehouse"
    ];

    brews = [
      "awscli"
      "beads" # AI task management for coding agents
      "bfg"
      "fswatch"
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
      "eugene1g/safehouse/agent-safehouse"
    ];

    casks = [
      "1password-cli"
      "beekeeper-studio"
      "codex"
      "discord"
      "deadbeef@nightly"
      "dotnet-sdk"
      "brave-browser@beta"
      "flux-app"
      "ghostty"
      "gstreamer-runtime"
      "iterm2"
      "mullvad-browser"
      "mullvad-vpn"
      "orbstack"
      "plexamp"
      "pocket-casts"
      "raycast"
      "spotify"
      "tailscale-app"
      "telegram"
      "todoist-app"
      "vimr"
      "vlc"
      "warp"
      "wine-stable"
      "wireshark-app"
    ];
  };
}

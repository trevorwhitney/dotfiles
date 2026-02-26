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
      "anomalyco/tap"
    ];

    brews = [
      "anomalyco/tap/opencode"
      "awscli"
      "bfg"
      "fswatch"
      "gnu-sed"
      "goose"
      "k6"
      "mas"
      "pipx" # for aider
      "python"
      "reattach-to-user-namespace"
      "telnet"
      "tree"
      "trivy"
      "trufflehog"
      "usbutils"
      "uv"
      "xk6"
      "zizmor"
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
      "todoist-app"
      "vimr"
      "vlc"
      "warp"
      "wine-stable"
      "wireshark-app"
    ];
  };
}

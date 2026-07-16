{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
      # Homebrew >= 5.1 requires --force with `brew bundle install --cleanup`.
      extraFlags = [ "--force" ];
    };

    taps = [
      "eugene1g/safehouse"
    ];

    brews = [
      "awscli"
      "bfg"
      "fswatch"
      "ffmpeg"
      "gitleaks"
      "gnu-sed"
      "k6"
      "mas"
      "node"
      "pipx"
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
      "little-snitch"
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
      "wine-stable"
      "wireshark-app"
    ];
  };
}

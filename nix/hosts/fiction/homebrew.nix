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

    # Taps live here rather than in `taps` because nix-darwin's tap submodule
    # cannot emit `trusted:`, which Homebrew >= 6 requires before it will load
    # formulae from a non-official tap.
    extraConfig = ''
      tap "eugene1g/safehouse", trusted: true
      tap "grafana/grafana", trusted: true
      tap "jundot/omlx", "https://github.com/jundot/omlx.git", trusted: true
    '';

    brews = [
      "awscli"
      "bfg"
      "fswatch"
      "ffmpeg"
      "gitleaks"
      "gnu-sed"
      "grafana/grafana/agento11y"
      "k6"
      "jundot/omlx/omlx"
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

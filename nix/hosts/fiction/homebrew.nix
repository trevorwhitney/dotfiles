{ pkgs, lib, config, ... }: {
  homebrew = {
    enable = true;
    onActivation = {
     autoUpdate = true;
     cleanup = "zap";
     upgrade = true;
    };

    brews = [
      "k6"
      "mas"
      "pam-reattach"
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
      "mullvadvpn"
      "plexamp"
      "raycast"
      "tailscale"
      "vimr"
      "vlc"
      "warp"
      "wireshark"
    ];
  };
}

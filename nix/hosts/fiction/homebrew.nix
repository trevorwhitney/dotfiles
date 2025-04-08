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
      "mullvad-browser"
      "mullvadvpn"
      "plexamp"
      "raycast"
      "tailscale"
      "vimr"
      "vlc"
      "wireshark"
    ];
  };
}

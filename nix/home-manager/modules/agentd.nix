{ config, pkgs, lib, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/workspace/dotfiles/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  stateDir = "${config.home.homeDirectory}/.local/state/agentd";
in
{
  home.packages = [ pkgs.agentd ];

  xdg.configFile."agentd/config.yaml".source = mkSymlink "${dotfilesPath}/agentd/config.yaml";

  home.activation.agentdStateDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${stateDir}"
  '';

  launchd.agents.agentd = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.agentd}/bin/agentd" "serve" ];
      RunAtLoad = true;
      KeepAlive = true;
      # launchd agents get a minimal PATH; the daemon shells out to gh, git,
      # tmux, nvim, and opencode.
      EnvironmentVariables.PATH = lib.concatStringsSep ":" [
        "${config.home.homeDirectory}/.nix-profile/bin"
        "/etc/profiles/per-user/${config.home.username}/bin"
        "/run/current-system/sw/bin"
        "/opt/homebrew/bin"
        "${config.home.homeDirectory}/.local/bin"
        "/usr/bin"
        "/bin"
      ];
      StandardOutPath = "${stateDir}/agentd.log";
      StandardErrorPath = "${stateDir}/agentd.log";
    };
  };
}

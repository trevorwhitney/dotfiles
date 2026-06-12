{ config, ... }:
let
  builderHost = "10.11.0.74";
  builderUser = "twhitney";
  builderKey = "${config.users.users.twhitney.home}/.config/agenix/id_ed25519";
  # Inline /etc/nix/machines line. builders-use-substitutes lets the builder pull
  # most paths from its own substituters instead of receiving every path over ssh.
  builderLine = "ssh-ng://${builderUser}@${builderHost} x86_64-linux ${builderKey} 2 1 big-parallel,benchmark,kvm,nixos-test - -";
in
{
  # nix-darwin's nix.buildMachines is a no-op under Determinate Nix (nix.enable = false),
  # so the builder and substitute settings are written via determinateNix.customSettings
  # (/etc/nix/nix.custom.conf), which the Determinate daemon actually reads.
  determinateNix.customSettings = {
    builders = builderLine;
    builders-use-substitutes = true;
  };

  # The root nix-daemon opens the ssh-ng builder connection as root. Pin mickey's host
  # key in /etc/ssh/ssh_known_hosts so the connection never blocks on an interactive
  # host-key prompt (the cause of the silent offload stall).
  programs.ssh.knownHosts.${builderHost} = {
    hostNames = [ builderHost ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqPHhMKAYIntu/Jx9Trl1bwIyMffwkkpSftd2WabuRZ";
  };

  # Keepalives + non-interactive host-key acceptance for the long-lived builder
  # connection, applied system-wide (root's ssh reads /etc/ssh/ssh_config).
  programs.ssh.extraConfig = ''
    Host ${builderHost}
      ServerAliveInterval 15
      ServerAliveCountMax 4
      TCPKeepAlive yes
      StrictHostKeyChecking accept-new
      IdentityFile ${builderKey}
  '';
}

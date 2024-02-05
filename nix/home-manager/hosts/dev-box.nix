{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/bash.nix
    ../modules/linux.nix
    ../modules/git.nix
    ../modules/k9s.nix
    ../modules/kubernetes.nix
    ../modules/neovim.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
  ];

  # Currently broken: https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = false;

  programs.git = {
    includes =
      [{ path = "${pkgs.secrets}/git"; }];
  };

  programs.neovim = {
    withLspSupport = true;
  };

  programs.gh = {
    enable = true;
  };

  programs.kubectl = {
    enable = true;
    package = pkgs.kubectl-1-25;
  };
}

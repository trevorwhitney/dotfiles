{ pkgs, lib, config, ... }: rec {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.twhitney = {
    imports = [
      ../home-manager/modules/alacritty.nix
      ../home-manager/modules/common.nix
      ../home-manager/modules/bash.nix
      ../home-manager/modules/git.nix
      ../home-manager/modules/i3.nix
      ../home-manager/modules/polybar.nix
      ../home-manager/modules/tmux.nix
      ../home-manager/modules/zsh.nix
      ../home-manager/modules/neovim.nix
      { programs.neovim = { withLspSupport = true; }; }
      { programs.git.gpgPath = with pkgs; "${gnupg}/bin/gpg"; }
    ];

    programs.git.includes =
      [{ path = "${pkgs.secrets}/git"; }];

    programs.zsh.sessionVariables = {
      LD_LIBRARY_PATH =
        "${pkgs.unstable.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
    };

    home.file.".local/share/backgrounds/family.jpg".source =
      "${pkgs.secrets}/backgrounds/family.jpg";
  };
}

{ config, pkgs, lib, ... }: {
  programs.bash = {
  # enabling bash makes sure ~/.profile is setup correctly
  # which some other things rely on
  enable = true;
  initExtra = builtins.concatStringsSep "\n" (with pkgs; [
      (lib.strings.fileContents ./lib/bashrc)
    ]);
};
}


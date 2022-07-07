{ config, pkgs, lib, ... }: {
  programs.bash = {
  enable = true;
  initExtra = builtins.concatStringsSep "\n" (with pkgs; [
      (lib.strings.fileContents ./lib/bashrc)
    ]);
};
}


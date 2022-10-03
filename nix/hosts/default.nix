{ pkgs, ... }: {
  stem = import ./stem.nix { inherit pkgs; };
}

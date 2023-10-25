{ self, nixos-generators }:
final: prev: {
  nvim-container = import ../packages/containers/nvim-container.nix {
    inherit self;
    pkgs = prev;
  };

  dev-container = import ../packages/containers/dev-container.nix
    {
      inherit self nixos-generators;
      inherit (prev) system;
      pkgs = prev;
    };

  # requires secrets which I don't want in any container
  # commenting out until I decide if I still want this
  # dev-box = import ../packages/images/dev-box.nix {
  #   inherit self nixos-generators;
  #   inherit (prev) system;
  #   pkgs = prev;
  # };
}

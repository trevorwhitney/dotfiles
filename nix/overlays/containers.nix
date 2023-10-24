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

  dev-box = import ../packages/images/dev-box.nix {
    inherit self nixos-generators;
    inherit (prev) system;
    pkgs = prev;
  };
}

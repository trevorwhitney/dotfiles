{ pkgs, deploy-rs, ... }:
let
  goPkg = pkgs.go;
  delvePkg = pkgs.delve;
  nodeJsPkg = pkgs.nodejs_22;
  golangciLintPkg = pkgs.golangci-lint;
  golangciLintLangServerPkg = pkgs.golangci-lint-langserver;

  # oldGoPkgs = import
  #   (builtins.fetchGit {
  #     # Descriptive name to make the store path easier to identify
  #     name = "go-1.21";
  #     url = "https://github.com/NixOS/nixpkgs/";
  #     ref = "refs/heads/nixpkgs-25.05-darwin";
  #     rev = "2c36ece932b8c0040893990da00034e46c33e3e7";
  #   })
  #   { system = pkgs.system; };
  # go_1_21 = oldGoPkgs.go_1_21;

  # oldDelvePkgs = import
  #   (builtins.fetchGit {
  #     # Descriptive name to make the store path easier to identify
  #     name = "delve-1.21.2";
  #     url = "https://github.com/NixOS/nixpkgs/";
  #     ref = "refs/heads/nixpkgs-25.05-darwin";
  #     rev = "8374ab2113c7522766acf5ab1af9d8c6824c06d4";
  #   })
  #   { system = pkgs.system; };
  # delve_1_21 = oldDelvePkgs.delve;
in
{
  default = import ./dev-env.nix {
    inherit pkgs;
    extraPackages = with pkgs; [
      deploy-rs.packages.${pkgs.system}.default
      home-manager
      libvirt
      nix
      qemu
      virt-manager
    ];
  };

  dev-env = import ./dev-env.nix { inherit pkgs goPkg delvePkg; };

  grafana = import ./grafana.nix {
    inherit pkgs goPkg delvePkg nodeJsPkg;
  };

  loki = import ./loki.nix {
    inherit pkgs goPkg delvePkg golangciLintPkg golangciLintLangServerPkg nodeJsPkg;
  };
  gel = import ./gel.nix { inherit pkgs goPkg delvePkg; };

  prometheus = import ./dev-env.nix {
    inherit pkgs goPkg delvePkg nodeJsPkg;
  };
}

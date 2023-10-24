{ self, pkgs, nixos-generators, system }: nixos-generators.nixosGenerate {
  inherit system;
  format = "vagrant-virtualbox";
  # minimal config without home-manager
  modules = [
    {
      nixpkgs = {
        inherit pkgs;
        hostPlatform = "x86_64-linux";
      };

      environment.systemPackages = with pkgs; [
        curl
        git
        home-manager
        man
        vim
        wget
      ];
    }

    "${self}/nix/modules/virtualbox.nix"
    "${self}/nix/modules/gc.nix"
    "${self}/nix/modules/binbash.nix"
    "${self}/nix/hosts/dev-box/configuration.nix"
    "${self}/nix/hosts/dev-box/vagrant.nix"
  ];
}

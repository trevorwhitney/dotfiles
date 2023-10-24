{ self, pkgs, nixos-generators, system, ... }:
# 1. nix build .#dev-container
# 2. podman import result/tarball/nixos-system-x86_64-linux.tar.gz dev-container
# 3. podman run --privileged --runtime runc --systemd=true --log-level=debug localhost/dev-container /init
# 4. from another shell, you can now exec into the container with: podman exec -it <CONTAINER_ID> /bin/zsh
nixos-generators.nixosGenerate {
  inherit system;
  format = "docker";
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

    "${self}/nix/modules/gc.nix"
    "${self}/nix/modules/binbash.nix"
    "${self}/nix/hosts/dev-container/configuration.nix"
  ];
}

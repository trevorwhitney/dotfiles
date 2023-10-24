{ system }: final: prev:
let
  virtualBoxVersion = "6.1.48";

  virtualbox-6_1-pkgs = import
    (builtins.fetchTarball {
      url =
        "https://github.com/NixOS/nixpkgs/archive/6adf48f53d819a7b6e15672817fa1e78e5f4e84f.tar.gz";
      sha256 = "0p7m72ipxyya5nn2p8q6h8njk0qk0jhmf6sbfdiv4sh05mbndj4q";
    })
    {
      inherit system;
    };
in
{
  # Virtualbox version 7.* doesn't work with my images, so keep on 6.*.
  virtualboxExtpack =
    prev.fetchurl
      rec {
        name = "Oracle_VM_VirtualBox_Extension_Pack-${virtualBoxVersion}.vbox-extpack";
        url = "https://download.virtualbox.org/virtualbox/${virtualBoxVersion}/${name}";
        sha256 =
          # Manually sha256sum the extensionPack file, must be hex!
          # Thus do not use `nix-prefetch-url` but instead plain old `sha256sum`.
          # Checksums can also be found at https://www.virtualbox.org/download/hashes/${version}/SHA256SUMS
          let value = "fee01ebd812b80db1391e87148b252cf1b0ab18d2720bcf61ff2701352a78e92";
          in assert (builtins.stringLength value) == 64; value;
      };

  virtualbox = virtualbox-6_1-pkgs.virtualbox.overrideAttrs (old: rec {
    version = virtualBoxVersion;
    src = prev.fetchurl {
      url = "https://download.virtualbox.org/virtualbox/${virtualBoxVersion}/VirtualBox-${virtualBoxVersion}.tar.bz2";
      sha256 = "CSUFwouLi4gEjVHDTx4WwCddxwYS1IENj0dYefD/Uxc=";
    };
  });

}

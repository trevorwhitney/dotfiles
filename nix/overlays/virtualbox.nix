{system}: final: prev:
let
  virtualBoxVersion = "6.1.44";

  virtualbox-6_1-pkgs = import (builtins.fetchTarball {
    url =
      "https://github.com/NixOS/nixpkgs/archive/6adf48f53d819a7b6e15672817fa1e78e5f4e84f.tar.gz";
    sha256 = "0p7m72ipxyya5nn2p8q6h8njk0qk0jhmf6sbfdiv4sh05mbndj4q";
  }) { 
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
          let value = "af1ed93125e723ae89d886a61c7fc4b20d2b3370c085a90403a3301293f7a4bd";
          in assert (builtins.stringLength value) == 64; value;
      };

  virtualbox = virtualbox-6_1-pkgs.virtualbox.overrideAttrs (old: rec {
    version = virtualBoxVersion;
    src = prev.fetchurl {
      url = "https://download.virtualbox.org/virtualbox/${virtualBoxVersion}/VirtualBox-${virtualBoxVersion}.tar.bz2";
      sha256 = "34a0235d878165453f6a15e34d74ed19b8878afacbb34e6f3682556f3487a48c";
    };
  });

}

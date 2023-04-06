{ pkgs }:
let
  virtualBoxVersion = "6.1.40";
in

final: prev: rec {
  inherit (pkgs)
    # Run the latest firefrox
    firefox-bin-unwrapped
    firefox-unwrapped

    # Run the latest KDE
    libsForQt5
    plasma5Packages

    lua-language-server;

  # Virtualbox needs the libsForQt5 overridden above, but the version in unstable (7)
  # doesn't work with my images, so force a downgrade to 6.1.40.

  virtualboxExtpack =
    prev.fetchurl
      rec {
        name = "Oracle_VM_VirtualBox_Extension_Pack-${virtualBoxVersion}.vbox-extpack";
        url = "https://download.virtualbox.org/virtualbox/${virtualBoxVersion}/${name}";
        sha256 =
          # Manually sha256sum the extensionPack file, must be hex!
          # Thus do not use `nix-prefetch-url` but instead plain old `sha256sum`.
          # Checksums can also be found at https://www.virtualbox.org/download/hashes/${version}/SHA256SUMS
          let value = "29cf8410e2514ea4393f63f5e955b8311787873679fc23ae9a897fb70ef3f84a";
          in assert (builtins.stringLength value) == 64; value;
      };

  virtualbox = pkgs.virtualbox.overrideAttrs (old: rec {
    version = virtualBoxVersion;
    src = prev.fetchurl {
      url = "https://download.virtualbox.org/virtualbox/${virtualBoxVersion}/VirtualBox-${virtualBoxVersion}.tar.bz2";
      sha256 = "bc857555d3e836ad9350a8f7b03bb54d2fdc04dddb2043d09813f4634bca4814";
    };
  });
}

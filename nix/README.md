# Nix

This folder contains all my nix recipies, both for NixOS and `home-manager`.

## Tips and Tricks

This section is for me to remember how to do things I don't do all the time.

### nix-alien

`nix-alien` is installed on my NixOS machines to allow me to run precompiled binaries that need to dynamically link to certain libraries. Here's an example using it with a precompiled `promtail` binary, which needs the `systemd` libraries for `journald` support:

```console
nix-alien -p gcc -p systemd -- ./promtail -config.file config.yaml
```

When trying to figure out the right combination of extra packages to add, don't forget to include the `--recreate` flag to force the creating of a new derivation with the latest list of packages.


### debugging


When creating a local package, the following command is useful:

```bash
nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
```

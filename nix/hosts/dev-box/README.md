# Virtual Box for Development

1. Run `nix build .#dev-box` from dotfiles root
1. Move built/updated image to `~/workspace/dev.box`
1. Symlink Vagrantfile to `~/workspace/Vagrantfile`
1. From `~/workspace` directory, run `vagrant up`
1. Run `vagrant ssh`, then `sudo bootstrap-dev-box` from inside VM


1. Run `vagrant ssh`, and find git in `/nix/store`
1. Run nixos build, pointing to the flake at the root of dotiles, with git manually added to the path

```console
sudo PATH="/nix/store/7smkn8cidx17la9ny5vfvghrwfxwbrny-git-2.42.0/bin:$PATH" nixos-rebuild switch --flake .
```

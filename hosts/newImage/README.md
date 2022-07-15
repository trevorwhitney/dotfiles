# Readme

Full guide: https://justinas.org/nixos-in-the-cloud-step-by-step-part-1
`$ morph deploy network.nix switch`

## Setting up home manager

1. SSH in as `twhitney`
1. `home-manager switch --flake github:trevorwhitney/dotfiles/42f662550194c39bb4b337114ca392c667fe41fc --no-write-lock-file` (with a specific sha)


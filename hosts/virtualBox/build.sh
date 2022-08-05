#!/bin/bash

# Before flakse
nix-build . -A withGnome
# With flakes
# nix build --impure

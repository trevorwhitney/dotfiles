#!/bin/bash

# Before flakse
# nix-build . -A withGnome

# With full home manager
# nix-build . -A withGnomeAndHM

# Just media image
nix-build . -A media

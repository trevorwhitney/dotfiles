#!/usr/bin/env bash

git clone git@github.com:koekeishiya/limelight.git "$HOME/workspace/limelight"
cd "$HOME/workspace/limelight" || exit 1
make
ln -s "$HOME/workspace/limelight/bin/limelight" /usr/local/bin/limelight

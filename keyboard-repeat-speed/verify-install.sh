#!/usr/bin/env bash

[[ $(defaults read NSGlobalDomain KeyRepeat = 2 2>/dev/null) && \
  $(defaults read NSGlobalDomain InitialKeyRepeat = 15 2> /dev/null) && \
  $(defaults read com.apple.finder AppleShowAllFiles = YES 2> /dev/null) ]]

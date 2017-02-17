#!/bin/bash

if [ ! `which stack` ]; then
  curl -sSL https://get.haskellstack.org/ | sh
  stack setup
fi

stack install hlint stylish-haskell hindent ghc-mod hdevtools fast-tags

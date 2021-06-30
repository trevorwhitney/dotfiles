#!/usr/bin/env zsh

set -euf

if [[ ! `command -v yarn` ]]; then
  npm install -g yarn
fi

npm install -g prettier
npm install -g markdownlint-cli

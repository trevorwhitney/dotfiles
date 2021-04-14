#!/usr/bin/env zsh

current_dir=$(cd "$(dirname "$0")" && pwd)

pushd "$current_dir/.." > /dev/null || exit 1
  rm -rf .git .gitignore .gitmodules .idea $(< pair-env-docker/dotexclude)
popd > /dev/null || exit 1
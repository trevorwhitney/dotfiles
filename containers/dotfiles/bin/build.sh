#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
dotfiles_containers_dir=$(cd $current_dir/.. && pwd)

for dir in ubuntu base vim; do
  pushd $dotfiles_containers_dir/$dir
    echo "Building dotfiles:${dir}"
    ./build.sh
  popd
done

pushd $dotfiles_containers_dir
  echo "Building dotfiles:latest"
  docker build -t dotfiles:latest --no-cache .
popd

#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
dotfiles_container_dir=$(cd $current_dir/.. && pwd)
dotfiles_dir=$(cd $dotfiles_container_dir/../.. && pwd)

pushd $dotfiles_dir
  tar -czf $dotfiles_container_dir/dotfiles.tar.gz --exclude containers .
popd
docker build -t dotfiles --no-cache $dotfiles_container_dir

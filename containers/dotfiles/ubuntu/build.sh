#!/bin/bash

set -ex

ubuntu_dir=$(cd $(dirname $0) && pwd)
dotfiles_dir=$(cd $ubuntu_dir/../../.. && pwd)

pushd $dotfiles_dir
  tar -czf $ubuntu_dir/dotfiles.tar.gz --exclude containers .
popd
docker build -t dotfiles:ubuntu --no-cache $ubuntu_dir

#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
dotfiles_container_dir=$(cd $current_dir/../containers/dotfiles && pwd)

$dotfiles_container_dir/bin/build.sh

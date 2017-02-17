#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

$current_dir/install_dependencies.sh
$current_dir/install_dotfiles.sh
$current_dir/install_vim.sh
$current_dir/install_neovim.sh
$current_dir/install_python.sh
$current_dir/install_ruby.sh
$current_dir/install_haskell.sh
$current_dir/install_powerline_fonts.sh
$current_dir/os_specific.sh

# Run Tests
$current_dir/shpec

exit 0

#!/usr/bin/env bash

command -v vim > /dev/null

vim_plugs_desired=$(cat ~/.vim/vimrc.bundles | wc -l)
vim_plugs_installed=$(ls -ld ~/.vim/plugged/* | wc -l)
echo "Vim plugs installed: ${vim_plugs_installed}/${vim_plugs_desired}"
test -e ~/.vim/vimrc.bundles && \
  test ${vim_plugs_desired} -eq ${vim_plugs_installed}

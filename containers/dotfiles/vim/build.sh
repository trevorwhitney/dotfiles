#!/bin/bash

vim_dir=$(cd $(dirname $0) && pwd)

docker build -t dotfiles:vim --no-cache $vim_dir

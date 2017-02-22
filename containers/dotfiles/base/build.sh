#!/bin/bash

base_dir=$(cd $(dirname $0) && pwd)
docker build -t dotfiles:base --no-cache $base_dir

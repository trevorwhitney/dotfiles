#!/bin/bash

set -ex

docker run dotfiles:latest /root/.dotfiles/ci/run_specs.sh

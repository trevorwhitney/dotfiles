#!/usr/bin/env zsh

set -e

command -v op > /dev/null
op --version > /dev/null


current_dir="$(cd $(dirname "$0") && pwd)"
current_version="$(cat "$current_dir/version" | sed 's/v//')"

if [[ "v$current_version" != "v$(op --version)" ]]; then exit 1; fi

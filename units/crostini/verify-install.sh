#!/usr/bin/env zsh

set -e

test -e "/usr/share/applications/firefox.desktop"

command -v firefox > /dev/null

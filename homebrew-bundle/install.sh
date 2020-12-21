#!/usr/bin/env bash
brewfile_directory=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

brew tap homebrew/bundle
brew upgrade

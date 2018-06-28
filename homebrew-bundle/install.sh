#!/bin/sh

brew tap homebrew/bundle

cd $(dirname $0)

brew bundle

#!/usr/bin/env zsh

current_dir=$(cd "$(dirname $0)" && pwd)

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# kns and ktx from https://github.com/blendle/kns
ln -s "$current_dir/kns" "$HOME/.local/bin/kns"
ln -s "$current_dir/ktx" "$HOME/.local/bin/ktx"

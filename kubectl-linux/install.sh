#!/usr/bin/env zsh

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

curl https://raw.githubusercontent.com/trevorwhitney/kns/master/bin/kns -o "$HOME/.local/bin/kns"  && chmod +x $_
curl https://raw.githubusercontent.com/trevorwhitney/kns/master/bin/ktx -o "$HOME/.local/bin/ktx"  && chmod +x $_

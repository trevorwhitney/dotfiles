#!/usr/bin/env bash

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88


if [[ ! -e /etc/apt/sources.list.d/docker.list ]]; then
  echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
fi

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

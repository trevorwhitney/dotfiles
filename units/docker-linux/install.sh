#!/usr/bin/env zsh

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

distribution="$(lsb_release -is)"

if [[ "$distribution" == "Pop" ]]; then
  distribution="Ubuntu"
fi


if [[ ! -e /etc/apt/sources.list.d/docker.list ]]; then
  dist="$(echo "${distribution}" | tr '[:upper:]' '[:lower:]')"
  echo "deb [arch=amd64] https://download.docker.com/linux/${dist} $(lsb_release -cs) stable"
  echo "deb [arch=amd64] https://download.docker.com/linux/${dist} $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
fi

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo curl -L "https://github.com/docker/compose/releases/download/2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

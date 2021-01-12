#!/usr/bin/env bash
codename="$(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2)"
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb ${codename} main" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list
sudo apt update
sudo apt-get install -y adoptopenjdk-11-hotspot adoptopenjdk-14-hotspot
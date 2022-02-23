#!/usr/bin/env bash
shopt -s nullglob
# enable the docker systemd unit
for unit in "${HOME}"/.nix-profile/etc/systemd/system/*.{service,timer,socket}; do
  echo "linking $(basename $unit)"
  sudo ln -sf "${unit}" "/etc/systemd/system/$(basename $unit)"
done

# enable tailscale systemd unit
for unit in "${HOME}"/.nix-profile/lib/systemd/system/*.{service,timer,socket}; do
  echo "linking $(basename $unit)"
  sudo ln -sf "${unit}" "/lib/systemd/system/$(basename $unit)"
done

sudo systemctl daemon-reload
sudo systemctl enable docker.socket
sudo systemctl enable docker.service
sudo systemctl enable nix-daemon.service

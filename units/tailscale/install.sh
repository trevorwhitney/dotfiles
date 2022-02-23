#!/usr/bin/env bash

host_path="${HOME}/.config/dotfiles/host.json"
host="$(cat "${host_path}" | jq -r '.name')"

. /etc/os-release
case "${ID}" in
ubuntu | pop)
  OS="ubuntu"
  ;;
debian) 
  OS="debian"
  ;;

*)
	echo "OS ${ID} not supported"
	exit 1
	;;
esac

curl -fsSL "https://pkgs.tailscale.com/stable/${OS}/$(lsb_release -cs).gpg" | sudo apt-key add -
curl -fsSL "https://pkgs.tailscale.com/stable/${OS}/$(lsb_release -cs).list" | sudo tee /etc/apt/sources.list.d/tailscale.list

sudo apt-get update
sudo apt-get install -y tailscale

if [[ "${host}" == "cerebral" ]]; then
  sudo tailscale up --advertise-exit-node --advertise-routes=10.11.0.0/24 --hostname=cerebral
else
  sudo tailscale up --hostname="${host}"
fi



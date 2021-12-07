#!/bin/bash

current_dir="$(cd "$(dirname "$0")" && pwd)"

current_version=$(<"$current_dir/version")
latest_version=$(curl --silent -L -H 'Accept: application/json' \
	https://github.com/barnumbirr/alacritty-debian/releases/latest |
	jq -r .tag_name |
	sed 's/v//')

if [[ "v$current_version" != "v$latest_version" ]]; then
	echo "Updating Alacritty from $current_version to $latest_version"
	echo "$latest_version" >"$current_dir/version"
	/bin/bash "$current_dir/install.sh"
fi

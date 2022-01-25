#!/bin/bash

current_dir="$(cd "$(dirname "$0")" && pwd)"
current_versions=$(<"$current_dir/versions.json")

function update_from_github_release() {
	process="$1"
	url="$2"

	current_version=$(echo "$current_versions" | jq -r ".$process")

	latest_version=$(curl --silent -L -H 'Accept: application/json' \
		"$url" |
		jq -r .tag_name |
		sed 's/v//')

	temp=$(mktemp)

	if [[ "v$current_version" != "v$latest_version" ]]; then
		echo "Updating $process from $current_version to $latest_version"
		jq ".$process = \"$latest_version\"" "$current_dir/versions.json" >"$temp"
		mv "$temp" "$current_dir/versions.json"
		# /bin/bash "$current_dir/install.sh"
	else
		echo "$process at most recent verstion $current_version"
	fi
}

update_from_github_release "process_exporter" "https://github.com/ncabatoff/process-exporter/releases/latest"

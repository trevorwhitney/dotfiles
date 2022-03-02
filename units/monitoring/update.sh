#!/bin/bash

current_dir="$(cd "$(dirname "$0")" && pwd)"
dotfiles_dir="$(cd "${current_dir}/../.." && pwd)"

source "${dotfiles_dir}/lib.sh"

versions_file="${current_dir}/versions.json"
current_version=$(echo "$(<"${versions_file}")" | jq -r ".$project")
update_from_github_release "process_exporter" \
	"https://github.com/ncabatoff/process-exporter/releases/latest" \
	"${versions_file}"

latest_version=$(echo "$(<"${versions_file}")" | jq -r ".$project")
if [[ "v$current_version" != "v$latest_version" ]]; then
	/bin/bash "${current_dir}/install.sh"
fi

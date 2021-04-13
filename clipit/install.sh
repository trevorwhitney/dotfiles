#!/usr/bin/env zsh
current_dir=$(cd $(dirname $0) && pwd)

tmp=$(mktemp -d)
version=$(cat $current_dir/version)

pushd ${tmp} > /dev/null || exit 1
  curl -LkO "https://github.com/CristianHenzel/ClipIt/releases/download/v$version/clipit_${version}_amd64.deb"
  curl -LkO "https://github.com/CristianHenzel/ClipIt/releases/download/v$version/clipit_${version}_amd64_indicator.deb"
  sudo dpkg -i ./clipit_${version}_amd64.deb
  sudo dpkg -i ./clipit_${version}_amd64_indicator.deb
popd > /dev/null || exit 1

rm -rf ${tmp}

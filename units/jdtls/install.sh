#!/bin/bash

set -e

current_dir="$(cd "$(dirname "$0")" && pwd)"
dotfiles_dir="$(cd "${current_dir}/../.." && pwd)"

source "${dotfiles_dir}/lib.sh"

artifact="$(download_from_github_tag jdtls \
	"https://github.com/eclipse/eclipse.jdt.ls/archive/refs/tags/v%v.tar.gz" \
	"eclipse.jdt.ls-%v.tar.gz" \
	"${current_dir}/versions.json")"

echo "installing ${artifact}"
pushd "$(dirname "${artifact}")" >/dev/null || exit 1
file="$(basename "${artifact}")"
tar -xzf "${file}"
pushd "${file//\.tar\.gz/}" >/dev/null || exit 1
./mvnw clean verify -DskipTests=true
mkdir -p "${HOME}/.local/share/jdtls"
rsync -av org.eclipse.jdt.ls.product/target/repository/ "${HOME}/.local/share/jdtls"
popd >/dev/null || exit 1
popd >/dev/null || exit 1

rm -rf "$(dirname "${artifact}")"

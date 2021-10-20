#!/usr/bin/env zsh
#
tmp_file="$(mktemp)"
go_17_version="1.17.2"
wget https://golang.org/dl/go${go_17_version}.linux-amd64.tar.gz -O "${tmp_file}"
tar -C /usr/local -xzf "${tmp_file}"
rm -rf /usr/local/go@1.17
mv /usr/local/go /usr/local/go@1.17

rm -rf "$tmp_file"

tmp_file="$(mktemp)"
go_16_version="1.16.9"
wget https://golang.org/dl/go${go_16_version}.linux-amd64.tar.gz -O "${tmp_file}"
tar -C /usr/local -xzf "${tmp_file}"
rm -rf /usr/local/go@1.16
mv /usr/local/go /usr/local/go@1.16

rm -rf "$tmp_file"

mkdir -p "$HOME/go"

#!/usr/bin/env zsh

tmp_file="$(mktemp)"
wget https://golang.org/dl/go1.16.9.linux-amd64.tar.gz -O "${tmp_file}"
tar -C /usr/local -xzf "${tmp_file}"
rm -rf /usr/local/go@1.16
mv /usr/local/go /usr/local/go@1.16

tmp_file="$(mktemp)"
wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz -O "${tmp_file}"
tar -C /usr/local -xzf "${tmp_file}"
rm -rf /usr/local/go@1.15
mv /usr/local/go /usr/local/go@1.15

tmp_file="$(mktemp)"
wget https://golang.org/dl/go1.14.14.linux-amd64.tar.gz -O "${tmp_file}"
tar -C /usr/local -xzf "${tmp_file}"
rm -rf /usr/local/go@1.14
mv /usr/local/go /usr/local/go@1.14

mkdir -p "$HOME/go"

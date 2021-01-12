#!/usr/bin/env bash

tmp_file="$(mktemp)"
echo tmp_file
wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz -O "${tmp_file}"

tar -C /usr/local -xzf "${tmp_file}"
#!/usr/bin/env bash
apt_updates="$(apt list --upgradable 2> /dev/null | head -n -1 | wc -l)"
flatpak_updates="$(flatpak remote-ls --updates 2> /dev/null | wc -l)"
bc <<< "${apt_updates} + ${flatpak_updates}"

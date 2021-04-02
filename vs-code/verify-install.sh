#!/usr/bin/env bash

test_code_link() {
    file_name="$(basename "$1" | sed "s/^\.//g")"
    code_location="$HOME/.config/Code/User/$file_name"

    test -h "$code_location" || test -e "$code_location"
}

test_code_link "$current_dir/keybindings.json"
test_code_link "$current_dir/settings.json"

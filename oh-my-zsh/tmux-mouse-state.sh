#!/usr/bin/env bash

[[ "$(tmux show-options -gv mouse)" == "on" ]] && echo "🐁"

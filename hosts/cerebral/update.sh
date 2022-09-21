#!/bin/sh

current_dir=$(cd "$(dirname "${0}")" && pwd)
root_dir=$(cd "${current_dir}/../.." && pwd)

home-manager switch --flake "${root_dir}" --impure

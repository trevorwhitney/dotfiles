#!/usr/bin/env bash
current_dir=$(cd $(dirname $0) && pwd)

BASH_COMPLETION_DIR="$HOME/.bash_completion.d"

# Linking files is good for configurations
# we want to track changes to
create_link() {
    if [[ -h "${BASH_COMPLETION_DIR}/$1" ]] || [[ -e "${BASH_COMPLETION_DIR}/$1" ]]; then
        rm -rf "${BASH_COMPLETION_DIR}/$1";
    fi

    ln -s "$current_dir/$1" "${BASH_COMPLETION_DIR}/$1"
}


mkdir -p ${BASH_COMPLETION_DIR}
create_link git.sh
create_link maven.sh

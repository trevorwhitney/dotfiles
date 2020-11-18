#!/usr/bin/env bash
brewfile_directory=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

brew tap homebrew/bundle

cd "$brewfile_directory" && brew bundle -v
if [[ ! `pgrep yabai` ]]; then
  if [[ `yabai --check-sa` ]]; then sudo yabai --install-sa; fi
  brew services start yabai
fi

if [[ ! `pgrep skhd` ]]; then
  brew services start skhd
fi

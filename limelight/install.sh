#!/usr/bin/env bash
current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

echo "Installing limelight"
git clone git@github.com:koekeishiya/limelight.git "$HOME/workspace/limelight"
pushd "$HOME/workspace/limelight" || exit 1
make
ln -s "$HOME/workspace/limelight/bin/limelight" /usr/local/bin/limelight
popd || exit 1

echo "Linking limelight config"
source "$dot_files_dir/lib.sh"
create_link "$current_dir/limelightrc"

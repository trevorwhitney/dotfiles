#!/usr/bin/env bash

# Linking files is good for configurations
# we want to track changes to
create_link() {
    file_name="$(basename "$1" | sed "s/^\.//g")"
    if [ -h "$HOME/.$file_name" ] || [ -e "$HOME/.$file_name" ]; then
      rm -rf "$HOME/.$file_name"
    fi

    ln -sf "$1" "$HOME/.$file_name"
}

# Linking files is good for configurations
# we want to track changes to. This creates a link in ~/.config/$1
create_config_link() {
    subdir_name="$1"
    mkdir -p "$HOME/.config/$subdir_name"
    file_name="$(basename "$2" | sed "s/^\.//g")"
    link="$HOME/.config/$subdir_name/$file_name"
    if [ -h "$link" ] || [ -e "$link" ]; then
      rm -rf "$link";
    fi

    ln -sf "$2" "$link"
}

# Linking files is good for configurations
# we want to track changes to. This creates a link in ~/.config/$1
create_xdg_data_link() {
    subdir_name="$1"
    mkdir -p "$HOME/.local/share/$subdir_name"
    file_name="$(basename "$2" | sed "s/^\.//g")"
    link="$HOME/.local/share/$subdir_name/$file_name"
    if [ -h "$link" ] || [ -e "$link" ]; then
      rm -rf "$link";
    fi

    ln -sf "$2" "$link"
}

# Copying files is good for configurations that might
# have local overrides, since we don't want to track
# the local overrides in version control
copy_file() {
    file_name="$(basename "$1" | sed "s/^\.//g")"
    if [ ! -e "$HOME/.$file_name" ]; then
      cp "$1" "$HOME/.$file_name"
    fi
}

create_alias_link() {
    file_name="$(basename "$1" | sed "s/^\.//g")"
    if [ -h "$HOME/.bash_aliases.d/$file_name" ] || [ -e "$HOME/.bash_aliases.d/$file_name" ]; then
      rm -rf "$HOME/.bash_aliases.d/$file_name";
    fi

    ln -s "$1" "$HOME/.bash_aliases.d/$file_name"
}

create_custom_zsh_link() {
    if [ -h "$HOME/.oh-my-zsh/custom/$1" ] || [ -e "$HOME/.oh-my-zsh/custom/$1" ]; then
        rm -rf "$HOME/.oh-my-zsh/custom/$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.oh-my-zsh/custom/$1"
}


create_alacritty_link() {
  file_name="$(basename "$1" | sed "s/^\.//g")"
  if [[ -h "$HOME/.config/alacritty/$file_name" ]] || [[ -e "$HOME/.config/alacritty/$file_name" ]]; then
    rm -rf "$HOME/.config/alacritty/$file_name"
  fi

  ln -sf "$1" "$HOME/.config/alacritty/$file_name"
}

update_github_ssh_keys() {
  mkdir -p $HOME/.ssh && chmod 0700 $HOME/.ssh
  ssh-keyscan github.com 1>> ~/.ssh/known_hosts 2>/dev/null
  sort $HOME/.ssh/known_hosts | uniq > $HOME/.ssh/known_hosts.uniq
  mv ~/.ssh/known_hosts{.uniq,}
}

op_signin() {
  set +e
  op list items 2>&1 > /dev/null 
  if [[ $? -ne 0 ]]; then
    eval "$(op signin my)"
  fi
  set -e
}

download_from_github_release() {
  project="$1"
  url="$2"
  package="$3"
  versions_file="$4"

  tmp=$(mktemp -d)
  version=$(jq -r ".$project" "$versions_file")

  pushd "$tmp" > /dev/null || exit 1
    extrapolated_url=${url//\%v/${version}}
    extrapolated_package=${package//\%v/${version}}
    curl -LkO "$extrapolated_url/$extrapolated_package"
  popd > /dev/null || exit 1

  echo "$tmp/$extrapolated_package"
}

download_from_github_tag() {
  project="$1"
  url="$2"
  package="$3"
  versions_file="$4"

  tmp=$(mktemp -d)
  version=$(jq -r ".$project" "$versions_file")

  pushd "$tmp" > /dev/null || exit 1
    extrapolated_url=${url//\%v/${version}}
    extrapolated_package=${package//\%v/${version}}
    curl -Lk "$extrapolated_url" -o "$extrapolated_package"
  popd > /dev/null || exit 1

  echo "$tmp/$extrapolated_package"
}

update_from_github_release() {
	project="$1"
	url="$2"
	versions_file="$3"

	current_versions=$(<"${versions_file}")
	current_version=$(echo "$current_versions" | jq -r ".$project")

	latest_version=$(curl --silent -L -H 'Accept: application/json' \
		"$url" |
		jq -r .tag_name |
		sed 's/v//')

	temp=$(mktemp)

	if [[ "v$current_version" != "v$latest_version" ]]; then
		echo "Updating $project from $current_version to $latest_version"
		jq ".$project = \"$latest_version\"" "${versions_file}" >"$temp"
		mv "$temp" "${versions_file}"
	else
		echo "$process at most recent verstion $current_version"
	fi
}

update_from_github_tag() {
	project="$1"
	url="$2"
	versions_file="$3"

	current_versions="$(cat "${versions_file}")"
	current_version=$(cat "$versions_file" | jq -r ".$project")

  latest_version=$(curl -L "$url" -H "Accept: application/json" | jq -r '.[0].name' | sed 's/v//')

	temp=$(mktemp)

	echo "comparing $project version v$current_version to v$latest_version"
	if [[ "v$current_version" != "v$latest_version" ]]; then
		echo "Updating $project from $current_version to $latest_version"
		jq ".$project = \"$latest_version\"" "${versions_file}" >"$temp"
		mv "$temp" "${versions_file}"
	else
		echo "$project at most recent verstion $current_version"
	fi
}

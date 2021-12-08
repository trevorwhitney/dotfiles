#!/usr/bin/env zsh

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

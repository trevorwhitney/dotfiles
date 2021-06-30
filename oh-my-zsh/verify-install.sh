#!/usr/bin/env zsh

set -e

test -e "$HOME/.oh-my-zsh"
test -e "$HOME/.zshrc"
test -e "$HOME/.oh-my-zsh/cache/.zsh-update"


test -e "$HOME/.oh-my-zsh/custom/aliases.zsh"
test -e "$HOME/.oh-my-zsh/custom/docker-completion.zsh"
test -e "$HOME/.oh-my-zsh/custom/docker-compose-completion.zsh"
test -e "$HOME/.oh-my-zsh/custom/gh-completion.zsh"
test -e "$HOME/.oh-my-zsh/custom/k3d-completion.zsh"
test -e "$HOME/.oh-my-zsh/custom/kubectl-completion.zsh"
test -e "$HOME/.oh-my-zsh/custom/themes/philips.zsh-theme"
test -e "$HOME/.oh-my-zsh/custom/themes/agnoster-gruvbox.zsh-theme"

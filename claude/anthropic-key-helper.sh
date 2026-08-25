#!/usr/bin/env bash
# claude's `apiKeyHelper` command: prints the Anthropic API key on stdout.
#
# Reading the agenix secret directly lets claude authenticate in contexts that
# never sourced an interactive shell. tmux run-shell jobs are the motivating
# case: worktree auto-naming runs there, and the ambient ANTHROPIC_API_KEY is
# empty, which left claude unauthenticated and stalling until its timeout.
#
# Path mirrors age.secretsDir in nix/home-manager/default.nix.
set -euo pipefail
exec cat "${HOME}/.agenix/secrets/anthropicApiKey"

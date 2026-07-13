#!/usr/bin/env bash
# workmux auto_name command. workmux execs this directly (no shell) and pipes
# the naming prompt on stdin, so the whole pipeline must live in a real script
# rather than a shell string in config.yaml. --system-prompt replaces claude's
# agentic prompt so it summarizes instead of acting; --tools "" keeps it out of
# "find and fix" mode. The tr/sed/awk tail is a hard failsafe that forces
# kebab-case and clamps to <=5 words even if the model emits a sentence.
set -euo pipefail

claude --model haiku --tools "" \
  --system-prompt "You are a text-to-branch-name converter. Output ONLY a kebab-case git branch name of at most 4 words summarizing the input. Lowercase, hyphen-separated, no other punctuation, no explanation, no sentences." \
  -p "$(cat)" \
  | tr '[:upper:]' '[:lower:]' \
  | tr -cs 'a-z0-9' '-' \
  | sed -E 's/-+/-/g; s/^-|-$//g' \
  | awk -F- '{n=(NF>5?5:NF); s=$1; for(i=2;i<=n;i++) s=s"-"$i; print s}'

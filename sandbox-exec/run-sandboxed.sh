#!/usr/bin/env bash
set -euo pipefail

# ===========================================================================
# run-sandboxed.sh -- Launch a command inside a sandbox-exec policy.
#
# Reads the durable profile from ~/.config/sandbox-exec/agent.sb and
# generates dynamic workdir, --add-dirs, and worktree rules at launch time.
# Writes a temporary policy file, runs sandbox-exec, then cleans up.
#
# Usage:
#   run-sandboxed.sh [options] [--] <command> [args...]
#
# Options:
#   --workdir=<path>         Explicit workdir (default: pwd -P)
#   --add-dirs=<p1:p2:...>   Colon-separated directories to grant read/write
#   --add-dirs-ro=<p1:p2:..> Colon-separated directories to grant read-only
#   --no-project-scope       Disable the dynamic per-project RW grant.
#                            By default, workdirs under ~/workspace/<project>/
#                            get RW access to the whole <project> directory
#                            so sibling worktrees and `workmux add` work.
#   --dry-run                Print the generated policy to stdout and exit
#
# Modeled on Agent Safehouse (github.com/eugene1g/agent-safehouse)
# ===========================================================================

DURABLE_PROFILE="${HOME}/.config/sandbox-exec/agent.sb"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

opt_workdir=""
opt_add_dirs=""
opt_add_dirs_ro=""
opt_dry_run=0
opt_no_project_scope=0
command_args=()

while [[ $# -gt 0 ]]; do
	case "$1" in
	--workdir=*)
		opt_workdir="${1#--workdir=}"
		shift
		;;
	--add-dirs=*)
		opt_add_dirs="${1#--add-dirs=}"
		shift
		;;
	--add-dirs-ro=*)
		opt_add_dirs_ro="${1#--add-dirs-ro=}"
		shift
		;;
	--dry-run)
		opt_dry_run=1
		shift
		;;
	--no-project-scope)
		opt_no_project_scope=1
		shift
		;;
	--)
		shift
		command_args+=("$@")
		break
		;;
	*)
		command_args+=("$1")
		shift
		;;
	esac
done

if [[ ${#command_args[@]} -eq 0 && $opt_dry_run -eq 0 ]]; then
	echo "Usage: run-sandboxed.sh [--workdir=<path>] [--add-dirs=<paths>] [--] <command> [args...]" >&2
	exit 1
fi

# ---------------------------------------------------------------------------
# Resolve effective workdir
# ---------------------------------------------------------------------------

if [[ -n "$opt_workdir" ]]; then
	effective_workdir="$(cd "$opt_workdir" && pwd -P)"
else
	effective_workdir="$(pwd -P)"
fi

# ---------------------------------------------------------------------------
# Helper: emit ancestor literal read rules for a path.
#
# For /Users/foo/projects/bar, emits:
#   (allow file-read*
#       (literal "/")
#       (literal "/Users")
#       (literal "/Users/foo")
#       (literal "/Users/foo/projects")
#   )
#
# Uses literal (not subpath) to grant readdir() on each ancestor without
# granting recursive read into their children.
# ---------------------------------------------------------------------------

emit_ancestor_literals() {
	local target_path="$1"
	local permission="${2:-file-read*}"
	local current=""
	local ancestors=()

	# Split path into components and build ancestor list.
	while IFS= read -r -d '/' component; do
		if [[ -n "$component" ]]; then
			current="${current}/${component}"
			ancestors+=("$current")
		fi
	done <<<"${target_path}/"

	if [[ ${#ancestors[@]} -eq 0 ]]; then
		return
	fi

	echo "  (allow ${permission}"
	echo "      (literal \"/\")"
	for ancestor in "${ancestors[@]}"; do
		# Don't emit the target path itself as an ancestor; the caller
		# grants the target path with subpath/literal separately.
		if [[ "$ancestor" != "$target_path" ]]; then
			echo "      (literal \"${ancestor}\")"
		fi
	done
	echo "  )"
}

# ---------------------------------------------------------------------------
# Helper: emit read/write grant for a directory (subpath) or file (literal).
# ---------------------------------------------------------------------------

emit_rw_grant() {
	local target_path="$1"
	if [[ -d "$target_path" ]]; then
		echo "  (allow file-read* file-write* (subpath \"${target_path}\"))"
	else
		echo "  (allow file-read* file-write* (literal \"${target_path}\"))"
	fi
}

# ---------------------------------------------------------------------------
# Helper: emit read-only grant for a directory (subpath) or file (literal).
# ---------------------------------------------------------------------------

emit_ro_grant() {
	local target_path="$1"
	if [[ -d "$target_path" ]]; then
		echo "  (allow file-read* (subpath \"${target_path}\"))"
	else
		echo "  (allow file-read* (literal \"${target_path}\"))"
	fi
}

# ---------------------------------------------------------------------------
# Git worktree detection
# ---------------------------------------------------------------------------

worktree_common_dir=""
linked_worktree_paths=()

detect_worktrees() {
	# Check if the workdir is a git worktree root.
	if ! git -C "$effective_workdir" rev-parse --is-inside-work-tree &>/dev/null; then
		return
	fi

	local git_dir
	git_dir="$(git -C "$effective_workdir" rev-parse --git-dir 2>/dev/null)" || return
	# Resolve to absolute path.
	if [[ "$git_dir" != /* ]]; then
		git_dir="${effective_workdir}/${git_dir}"
	fi
	git_dir="$(cd "$git_dir" && pwd -P)"

	# Check if this is a linked worktree (has a commondir file).
	if [[ -f "${git_dir}/commondir" ]]; then
		local common_rel
		common_rel="$(cat "${git_dir}/commondir")"
		if [[ "$common_rel" != /* ]]; then
			common_rel="${git_dir}/${common_rel}"
		fi
		worktree_common_dir="$(cd "$common_rel" && pwd -P)"
	elif [[ -d "${git_dir}/worktrees" ]]; then
		# This is the main worktree; its .git IS the common dir.
		worktree_common_dir="$git_dir"
	fi

	# Enumerate linked worktree paths (excluding the current workdir).
	if [[ -n "$worktree_common_dir" && -d "${worktree_common_dir}/worktrees" ]]; then
		local wt_name wt_gitdir wt_path
		for wt_name in "${worktree_common_dir}/worktrees"/*/; do
			[[ -d "$wt_name" ]] || continue
			wt_gitdir="${wt_name}gitdir"
			if [[ -f "$wt_gitdir" ]]; then
				wt_path="$(cat "$wt_gitdir")"
				# gitdir file contains path to the .git file in the worktree root;
				# strip the trailing /.git to get the worktree root.
				wt_path="${wt_path%/.git}"
				if [[ "$wt_path" != /* ]]; then
					wt_path="${worktree_common_dir}/worktrees/$(basename "${wt_name%/}")/${wt_path}"
				fi
				wt_path="$(cd "$wt_path" 2>/dev/null && pwd -P)" || continue
				# Skip if this is the current workdir.
				if [[ "$wt_path" != "$effective_workdir" ]]; then
					linked_worktree_paths+=("$wt_path")
				fi
			fi
		done
	fi
}

detect_worktrees

# ---------------------------------------------------------------------------
# Project-scope detection
#
# Layout convention: ~/workspace/<project>/<worktree-or-subdir>[/...]
# If the workdir lives under ~/workspace/<X>/<...>, the project root is
# ~/workspace/<X> and we grant RW on the whole project subtree. This covers
# the current worktree, all sibling worktrees in the same project, and the
# git worktree common dir (which lives under the project root in this layout).
#
# Skipped when:
#   - --no-project-scope is set
#   - workdir is not under ~/workspace
#   - workdir IS ~/workspace itself, or a direct child (no project subdir to
#     scope to -- workdir RW already covers the single level).
# ---------------------------------------------------------------------------

project_root=""

detect_project_root() {
	[[ $opt_no_project_scope -eq 1 ]] && return

	local ws_prefix="${HOME}/workspace"
	# Must be strictly under ~/workspace/.
	[[ "$effective_workdir" == "$ws_prefix"/* ]] || return

	local rel="${effective_workdir#${ws_prefix}/}"
	# rel must contain at least one '/', i.e. workdir is at depth >= 2 below
	# ~/workspace. A top-level child (~/workspace/foo) has rel == "foo" with
	# no slash -- no project subdir to derive, skip.
	[[ "$rel" == */* ]] || return

	local project_name="${rel%%/*}"
	[[ -n "$project_name" ]] || return

	project_root="${ws_prefix}/${project_name}"
	# Sanity: project root must exist and be a directory.
	[[ -d "$project_root" ]] || project_root=""
}

detect_project_root

# Drop linked worktrees from the dynamic RO emission if they're already
# covered by project_root (i.e. they live under the same project). In your
# layout this is always true, so the list typically ends up empty.
if [[ -n "$project_root" ]]; then
	filtered_wts=()
	for wt_path in "${linked_worktree_paths[@]:-}"; do
		[[ -z "$wt_path" ]] && continue
		if [[ "$wt_path" != "$project_root"* ]]; then
			filtered_wts+=("$wt_path")
		fi
	done
	linked_worktree_paths=("${filtered_wts[@]:-}")
fi

# ---------------------------------------------------------------------------
# Build dynamic policy section
# ---------------------------------------------------------------------------

build_dynamic_policy() {
	echo ""
	echo ";; ==========================================================================="
	echo ";; Dynamic rules generated at launch: $(date -Iseconds)"
	echo ";; Workdir: ${effective_workdir}"
	if [[ -n "$project_root" ]]; then
		echo ";; Project root (RW): ${project_root}"
	elif [[ $opt_no_project_scope -eq 1 ]]; then
		echo ";; Project scope: disabled (--no-project-scope)"
	fi
	if [[ -n "$opt_add_dirs" ]]; then
		echo ";; --add-dirs: ${opt_add_dirs}"
	fi
	if [[ -n "$opt_add_dirs_ro" ]]; then
		echo ";; --add-dirs-ro: ${opt_add_dirs_ro}"
	fi
	echo ";; ==========================================================================="

	# -- Workdir ancestor literals --
	echo ""
	echo ";; Workdir ancestor directory literals (readdir on each ancestor)."
	emit_ancestor_literals "$effective_workdir"

	# -- Workdir read/write grant --
	echo ""
	echo ";; Workdir read/write access."
	emit_rw_grant "$effective_workdir"

	# -- Project root (read/write) --
	# Grants RW on ~/workspace/<project>/, covering sibling worktrees and
	# the git common dir (which both live under the project root in this
	# layout). Subsumes the per-workdir grant above and any same-project
	# worktree paths -- those are left in the output for documentation.
	if [[ -n "$project_root" ]]; then
		echo ""
		echo ";; Project root read/write access (sibling worktrees + workmux add)."
		emit_ancestor_literals "$project_root"
		emit_rw_grant "$project_root"
	fi

	# -- Worktree common dir (read/write) --
	# Only emit if NOT already covered by project_root (e.g. unusual layouts
	# where the common dir lives outside ~/workspace/<project>/).
	if [[ -n "$worktree_common_dir" \
		&& "$worktree_common_dir" != "${effective_workdir}"* \
		&& ( -z "$project_root" || "$worktree_common_dir" != "${project_root}"* ) ]]; then
		echo ""
		echo ";; Git worktree common dir (shared metadata lives outside workdir/project)."
		emit_ancestor_literals "$worktree_common_dir"
		emit_rw_grant "$worktree_common_dir"
	fi

	# -- Sibling worktrees (read-only) --
	# Emitted only for worktrees outside the project root (rare in this
	# layout; same-project siblings are covered by the project_root RW grant
	# above and were filtered out of linked_worktree_paths).
	if [[ ${#linked_worktree_paths[@]} -gt 0 ]]; then
		echo ""
		echo ";; Out-of-project git worktrees (read-only snapshot at launch time)."
		for wt_path in "${linked_worktree_paths[@]}"; do
			[[ -z "$wt_path" ]] && continue
			emit_ancestor_literals "$wt_path"
			emit_ro_grant "$wt_path"
		done
	fi

	# -- --add-dirs (read/write) --
	if [[ -n "$opt_add_dirs" ]]; then
		echo ""
		echo ";; Additional read/write directories (--add-dirs)."
		IFS=':' read -ra add_rw_dirs <<<"$opt_add_dirs"
		for dir in "${add_rw_dirs[@]}"; do
			[[ -z "$dir" ]] && continue
			local resolved
			resolved="$(cd "$dir" 2>/dev/null && pwd -P)" || {
				echo "Warning: --add-dirs path does not exist: $dir" >&2
				continue
			}
			emit_ancestor_literals "$resolved"
			emit_rw_grant "$resolved"
		done
	fi

	# -- --add-dirs-ro (read-only) --
	if [[ -n "$opt_add_dirs_ro" ]]; then
		echo ""
		echo ";; Additional read-only directories (--add-dirs-ro)."
		IFS=':' read -ra add_ro_dirs <<<"$opt_add_dirs_ro"
		for dir in "${add_ro_dirs[@]}"; do
			[[ -z "$dir" ]] && continue
			local resolved
			resolved="$(cd "$dir" 2>/dev/null && pwd -P)" || {
				echo "Warning: --add-dirs-ro path does not exist: $dir" >&2
				continue
			}
			emit_ancestor_literals "$resolved"
			emit_ro_grant "$resolved"
		done
	fi
}

# ---------------------------------------------------------------------------
# Assemble final policy
# ---------------------------------------------------------------------------

if [[ ! -f "$DURABLE_PROFILE" ]]; then
	echo "Error: durable profile not found at ${DURABLE_PROFILE}" >&2
	exit 1
fi

# Read the durable profile, then append dynamic rules.
policy_content="$(cat "$DURABLE_PROFILE")$(build_dynamic_policy)"

# ---------------------------------------------------------------------------
# Dry-run mode
# ---------------------------------------------------------------------------

if [[ $opt_dry_run -eq 1 ]]; then
	echo "$policy_content"
	exit 0
fi

# ---------------------------------------------------------------------------
# Write temporary policy and launch sandbox-exec
# ---------------------------------------------------------------------------

tmp_policy=""
cleanup() {
	[[ -n "$tmp_policy" && -f "$tmp_policy" ]] && rm -f "$tmp_policy"
}
trap cleanup EXIT INT TERM

tmp_policy="$(mktemp "${TMPDIR:-/tmp}/agent-sandbox-policy.XXXXXX")"
echo "$policy_content" >"$tmp_policy"

exec sandbox-exec -f "$tmp_policy" "${command_args[@]}"

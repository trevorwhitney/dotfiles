{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.dotfiles.liveLinks;

  # Links that point straight at the working copy, instead of going through
  # the read-only home-manager-files store path like mkOutOfStoreSymlink does.
  # Apps that save via write-temp-then-rename next to the first link (Claude
  # Code, Zed, ...) fail with EPERM on the store hop.
  ensureLiveLinks = pkgs.writeShellApplication {
    name = "ensure-live-links";
    text = ''
      status=0

      ensure_link() {
        local target="$1"
        local src="$2"

        if [[ ! -e "$src" ]]; then
          echo "ensure-live-links: skipping $target, $src does not exist" >&2
          status=1
          return
        fi

        if [[ -L "$target" ]]; then
          if [[ "$(readlink "$target")" == "$src" ]]; then
            return
          fi
        elif [[ -e "$target" ]]; then
          echo "ensure-live-links: skipping $target, a real file is in the way; move it aside and rerun" >&2
          status=1
          return
        fi

        # Keep going on failure so one bad link doesn't block the rest.
        if ! mkdir -p "$(dirname "$target")" || ! ln -sfn "$src" "$target"; then
          echo "ensure-live-links: failed to link $target" >&2
          status=1
          return
        fi
        echo "ensure-live-links: $target -> $src"
      }

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList
        (target: src: "ensure_link ${lib.escapeShellArg target} ${lib.escapeShellArg src}")
        cfg)}

      exit "$status"
    '';
  };
in
{
  options = {
    dotfiles.liveLinks = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        "/Users/me/.claude/settings.json" = "/Users/me/workspace/dotfiles/dotfiles/claude/settings.json";
      };
      description = ''
        Symlinks to create, keyed by absolute link path, pointing at absolute
        paths in the dotfiles working copy so they can be edited live.
      '';
    };
  };

  config = lib.mkIf (cfg != { }) {
    home.packages = [ ensureLiveLinks ];

    # Run after linkGeneration so home-manager has already cleaned up any
    # store links it used to manage at these paths. Problems are reported
    # but don't abort the rest of activation.
    home.activation.ensureLiveLinks = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run ${ensureLiveLinks}/bin/ensure-live-links || true
    '';
  };
}

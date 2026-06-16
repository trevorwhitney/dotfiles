{ self, pkgs, ... }:
let
  inherit (pkgs) lib;
  goPkg = pkgs.go;
  nodeJsPkg = pkgs.nodejs_22;

  # Homebrew 6.0 made HOMEBREW_REQUIRE_TAP_TRUST default to true: third-party
  # taps/formulae must be trusted via `brew trust` before `brew bundle` will load
  # them. The trust file is read from "$HOME/.homebrew/trust.json" when
  # XDG_CONFIG_HOME is unset, which is exactly the case during the nix-darwin
  # homebrew activation (it runs `sudo --preserve-env=PATH ... env brew bundle`,
  # stripping XDG_CONFIG_HOME). We seed that file from the system activation
  # script *before* the homebrew bundle step so the eugene1g/safehouse tap is
  # trusted declaratively.
  homebrewTrustJSON = builtins.toJSON {
    trustedtaps = [ "eugene1g/safehouse" ];
    trustedformulae = [ "eugene1g/safehouse/agent-safehouse" ];
  };
  homebrewTrustUser = "twhitney";
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    goPkg

    (neovim {
      inherit goPkg nodeJsPkg;
      withLspSupport = true;
    })

    (azure-cli.withExtensions [
      azure-cli-extensions.account
    ])
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        beta
        alpha
        gke-gcloud-auth-plugin
        cloud-sql-proxy
      ]
    ))

    argo
    ast-grep
    bat
    bind
    claude-code
    cmake
    coreutils
    curl
    diffutils
    fd
    fzf
    gcalcli
    gnused
    gnumake
    golangci-lint
    jq
    k9s
    lsof
    lua51Packages.luarocks
    luajit
    mosh
    mariadb.client
    ncurses
    ngrok
    nil
    nixpkgs-fmt
    nmap
    opencode
    pre-commit
    rbenv
    ripgrep
    slackcli
    statix
    todoist-cli
    unixtools.watch
    workmux
    virtualenv
    yarn
    yq-go

    (pkgs.writeShellScriptBin "fix" ''
      function show_spinner() {
        local pid=''$1
        local delay=0.1
        local spinstr='|/-\'
        echo -n "Claude is thinking... "

        while kill -0 "''$pid" 2>/dev/null; do
        local temp=''${spinstr#?}
        printf " [%c]  " "''$spinstr"
        local spinstr=''$temp''${spinstr%"''$temp"}
        sleep ''$delay
        printf "\b\b\b\b\b\b"
        done
      }

      function fix_with_claude() {
        if [ -z "''$TMUX" ]; then
        echo "Not in a tmux session. Cannot capture pane output."
        return 1
        fi

        ${claude-code}/bin/claude \
        -p "The last command I ran in my zsh terminal failed. Here's the last 100 lines of output. Please help me understand and fix it, or tell me if you need more lines or context. Suggest a corrected command or next steps.\n\n''$(${tmux}/bin/tmux capture-pane -p -S -100)" \
        --permission-mode acceptEdits \
        --allowedTools "Bash(*),Read:*:.,Edit:*:."
      }

      fix_with_claude &
      claude_pid=''$!
      show_spinner ''$claude_pid
      wait ''$claude_pid
    '')

  ];

  environment.variables = {
    EDITOR = "vim";
  };

  # Seed Homebrew's tap trust file before the homebrew bundle activation step runs.
  # `mkBefore` prepends this to the `system.activationScripts.homebrew.text` block,
  # ensuring the trust file exists before `brew bundle` is invoked. Written as the
  # target user (activation runs as root) to both the XDG and fallback locations.
  system.activationScripts.homebrew.text = lib.mkBefore ''
    echo >&2 "Seeding Homebrew tap trust for ${homebrewTrustUser}..."
    homebrew_trust_home="$(/usr/bin/dscl . -read /Users/${homebrewTrustUser} NFSHomeDirectory | /usr/bin/awk '{print $2}')"
    if [ -n "$homebrew_trust_home" ]; then
      for trust_dir in "$homebrew_trust_home/.homebrew" "$homebrew_trust_home/.config/homebrew"; do
        /usr/bin/sudo -u ${homebrewTrustUser} /bin/mkdir -p "$trust_dir"
        printf '%s\n' ${lib.escapeShellArg homebrewTrustJSON} \
          | /usr/bin/sudo -u ${homebrewTrustUser} /usr/bin/tee "$trust_dir/trust.json" >/dev/null
        /usr/bin/sudo -u ${homebrewTrustUser} /bin/chmod 600 "$trust_dir/trust.json"
      done
    fi
  '';

  # General Nix settings
  nix = {
    settings = {
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";
      download-buffer-size = 671088640;
      http-connections = 5;
    };
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # OSX defaults
  system = {
    defaults = {
      dock.appswitcher-all-displays = true;
    };
  };

  # The platform the configuration will be used on.
  # nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs = {
    inherit pkgs;
    hostPlatform = "aarch64-darwin";
  };

  programs = {
    # Create /etc/zshenv -> /etc/static/zshenv so the nix-darwin
    # set-environment script (which seeds /run/current-system/sw/bin and the
    # user nix profile onto PATH) runs for ALL zsh shells, including the
    # non-interactive `zsh -c` invocations used by coding-agent shell tools.
    # Without this, agents launched outside an interactive/login shell get a
    # bare PATH and cannot find system-profile binaries like slackcli.
    zsh = {
      enable = true;
    };

    tmux = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };

  # Increase system-wide open file limits to avoid "Too many open files" errors
  # during large Nix builds. Setting NumberOfFiles on a system-wide daemon also
  # adjusts kern.maxfiles (soft) and kern.maxfilesperproc (hard) via sysctl.
  launchd.daemons.limit-maxfiles = {
    serviceConfig = {
      Label = "limit.maxfiles";
      ProgramArguments = [
        "/bin/launchctl"
        "limit"
        "maxfiles"
        "524288"
        "524288"
      ];
      RunAtLoad = true;
      SoftResourceLimits = {
        NumberOfFiles = 524288;
      };
      HardResourceLimits = {
        NumberOfFiles = 524288;
      };
    };
  };
}

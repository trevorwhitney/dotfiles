# Installs ~/Applications/Brave Beta (Debug).app — a tiny wrapper bundle that
# launches Brave Browser Beta with --remote-debugging-port=9222 so pi's
# browser-harness can attach via CDP. Pin this to the Dock and point Raycast at
# it; the real Brave Browser Beta.app is left untouched (so Brave's auto-updater
# can't break the shim).
{ pkgs
, config
, lib
, ...
}:
let
  appName = "Brave Beta (Debug)";
  bundleId = "com.twhitney.brave-beta-debug";
  remoteDebuggingPort = 9222;
  braveAppPath = "/Applications/Brave Browser Beta.app";
  braveBundleName = "Brave Browser Beta";
  appDir = "${config.home.homeDirectory}/Applications/${appName}.app";

  infoPlist = pkgs.writeText "brave-beta-debug-Info.plist" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleDevelopmentRegion</key><string>en</string>
      <key>CFBundleDisplayName</key><string>${appName}</string>
      <key>CFBundleExecutable</key><string>launcher</string>
      <key>CFBundleIconFile</key><string>app</string>
      <key>CFBundleIdentifier</key><string>${bundleId}</string>
      <key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
      <key>CFBundleName</key><string>${appName}</string>
      <key>CFBundlePackageType</key><string>APPL</string>
      <key>CFBundleShortVersionString</key><string>1.0</string>
      <key>CFBundleVersion</key><string>1</string>
      <key>LSMinimumSystemVersion</key><string>10.14</string>
    </dict>
    </plist>
  '';

  launcherScript = pkgs.writeShellScript "brave-beta-debug-launcher" ''
    # Launch (or reuse) Brave Browser Beta with --remote-debugging-port.
    # `open -na` always spawns a fresh instance with the flag; if Brave is
    # already running without the flag, quit it first so the flag actually
    # takes effect.
    if /usr/bin/pgrep -f ${lib.escapeShellArg "${braveAppPath}/Contents/MacOS/${braveBundleName}"} >/dev/null; then
      # Brave is already running. Check whether the running process already has
      # the flag; if so, just focus the app. Otherwise quit and relaunch.
      if /bin/ps -ww -A -o args= | /usr/bin/grep -F ${lib.escapeShellArg "${braveAppPath}/Contents/MacOS/${braveBundleName}"} | /usr/bin/grep -q -- --remote-debugging-port=${toString remoteDebuggingPort}; then
        exec /usr/bin/open -a ${lib.escapeShellArg braveBundleName}
      fi
      /usr/bin/osascript -e 'quit app "${braveBundleName}"' >/dev/null 2>&1 || true
      # Wait briefly for clean shutdown.
      for _ in 1 2 3 4 5 6 7 8 9 10; do
        /usr/bin/pgrep -f ${lib.escapeShellArg "${braveAppPath}/Contents/MacOS/${braveBundleName}"} >/dev/null || break
        /bin/sleep 0.5
      done
    fi
    exec /usr/bin/open -na ${lib.escapeShellArg braveBundleName} \
      --args --remote-debugging-port=${toString remoteDebuggingPort}
  '';
in
{
  home.activation.installBraveBetaDebugLauncher =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -eu

      appDir=${lib.escapeShellArg appDir}
      braveIcon=${lib.escapeShellArg "${braveAppPath}/Contents/Resources/app.icns"}
      infoPlist=${infoPlist}
      launcher=${launcherScript}

      # Idempotency stamp: store the resolved store paths of our inputs so we
      # only rebuild the bundle when Nix-tracked content actually changes.
      stamp="$appDir/Contents/.nix-build-stamp"
      expected="$infoPlist:$launcher"

      if [ -f "$stamp" ] \
        && [ "$(/bin/cat "$stamp" 2>/dev/null)" = "$expected" ] \
        && [ -f "$appDir/Contents/Resources/app.icns" ]; then
        exit 0
      fi

      echo "installing $appDir"

      /bin/rm -rf "$appDir"
      /bin/mkdir -p "$appDir/Contents/MacOS" "$appDir/Contents/Resources"

      /bin/cp "$infoPlist" "$appDir/Contents/Info.plist"
      /bin/cp "$launcher"  "$appDir/Contents/MacOS/launcher"
      /bin/chmod +x "$appDir/Contents/MacOS/launcher"

      if [ -f "$braveIcon" ]; then
        /bin/cp "$braveIcon" "$appDir/Contents/Resources/app.icns"
      else
        echo "brave-beta-debug: WARNING — ${braveAppPath} not installed yet; the wrapper will use a generic icon until the next rebuild"
      fi

      /usr/bin/printf '%s' "APPL????" > "$appDir/Contents/PkgInfo"

      /usr/bin/printf '%s' "$expected" > "$stamp"

      # Touch the bundle so LaunchServices / Finder pick up the changes.
      /usr/bin/touch "$appDir"

      # Re-register with LaunchServices so Spotlight / Raycast / open(1) find it.
      lsregister=/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister
      if [ -x "$lsregister" ]; then
        "$lsregister" -f "$appDir" >/dev/null 2>&1 || true
      fi
    '';
}

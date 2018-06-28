#!/usr/bin/env bash
git clone https://github.com/pivotal-legacy/pivotal_ide_prefs.git ~/workspace/pivotal_ide_prefs/

# Run the install scripts for the relevant IDE preferences
cd ~/workspace/pivotal_ide_prefs/cli

bin/ide_prefs install --ide=intellij
bin/ide_prefs install --ide=webstorm
bin/ide_prefs install --ide=gogland


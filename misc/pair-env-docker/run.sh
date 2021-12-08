#!/usr/bin/env zsh

set -euo pipefail

set -x

# the purge can fail when /etc/ssh is a mounted volume in k8s
# so try it to delete what we can, but don't stop the script if it fails
set +e
# reinstall openssh if no config provided
test -e /etc/ssh/sshd_config || { dpkg --purge openssh-server; apt-get install -y openssh-server; }
set -e

# home directory won't exsist on first boot since the user was created during docker file build
# before the volume is mounted
if [[ ! -e /home/pair ]]; then
    mkdir -p /home/pair
    chown -R pair:pair /home/pair
fi

exec /lib/systemd/systemd

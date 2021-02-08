#!/usr/bin/env bash
temp="$(mktemp -d)"

sudo apt-get install -y libusb-dev \
  libusb-1.0-0 \
  libbluetooth3-dev \
  libbluetooth3 \
  libdbus-1-dev \
  libdbus-1-3 \
  libdbus-glib-1-dev \
  libdbus-glib-1-2 \
  libjack-dev \
  libjack0 \
  bluez \
  udev \
  python-qt4-dev \
  python-qt4 \
  python-dbus \
  pyqt4-dev-tools \
  bluez-hcidump \
  libnotify4 \
  libnotify-dev \
  xdg-utils

pushd "${temp}" || exit 1
git clone git@github.com:falkTX/qtsixa.git
  cd qtsixa
  make
  sudo make install
popd

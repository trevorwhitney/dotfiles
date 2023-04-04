{ config, pkgs, lib, ... }:
{
  xdg = {
    enable = true;

    mimeApps = {
      enable = true;
    };
  };
}

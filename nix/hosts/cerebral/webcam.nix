{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    v4l-utils
  ];

  services.udev = {
    extraRules = with pkgs; ''
      SUBSYSTEM=="video4linux", KERNEL=="video[0-9]*", ATTR{index}=="0", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0892", RUN+="${v4l-utils}/bin/v4l2-ctl -d $devnode --set-fmt-video=width=1920,height=1080,pixelformat=MJPG"
      SUBSYSTEM=="video4linux", KERNEL=="video[0-9]*", ATTR{index}=="0", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0892", RUN+="${v4l-utils}/bin/v4l2-ctl -d $devnode -p 30"
    '';
  };
}

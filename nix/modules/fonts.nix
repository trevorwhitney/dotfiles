{ pkgs, ... }: {
  fonts = {
    fontconfig.enable = true;

    enableDefaultPackages = false;
    packages = with pkgs; [
      dejavu_fonts
      fontconfig
      roboto
      siji
      (nerdfonts.override {
        fonts = [
          "CascadiaCode"
          "DroidSansMono"
          "FantasqueSansMono"
          "FiraCode"
          "Hack"
          "Iosevka"
          "JetBrainsMono"
          "Noto"
          "Terminus"
          "Ubuntu"
          "UbuntuMono"
          "VictorMono"
        ];
      })
    ];
  };
}

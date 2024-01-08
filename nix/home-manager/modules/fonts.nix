{ config, pkgs, lib, ... }: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
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
}

{ config, pkgs, lib, ... }: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    xorg.xfd

    xdg-desktop-portal

    dejavu_fonts
    emote
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
        /* Iosevka is failing to download */
        /* "Iosevka" */
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

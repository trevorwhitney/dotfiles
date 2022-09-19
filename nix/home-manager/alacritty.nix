{ config, pkgs, lib, ... }:
let
  inherit (pkgs) dotfiles;
  cfg = config.programs.alacritty;
in
{
  options = {
    programs.alacritty = {
      theme = lib.mkOption {
        type = lib.types.str;
        default = "solarized";
        description = "which theme to use, can be solarized or gruvbox";
      };

      lightTheme = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "whether to apply a light color scheme";
      };

      opacity = lib.mkOption {
        type = lib.types.str;
        default = "1";
        description = "opacity of window";
      };
    };
  };

  config =
    let
      inherit (cfg) opacity;
      themeFile =
        if cfg.theme == "solarized" then
          if cfg.lightTheme then "solarized" else "solarized-dark"
        else if cfg.lightTheme then
          "gruvbox"
        else
          "gruvbox-dark";
      altThemeFile =
        if cfg.theme == "solarized" then
          if cfg.lightTheme then "solarized-dark" else "solarized"
        else if cfg.lightTheme then
          "gruvbox-dark"
        else
          "gruvbox";
      gtkThemeVariant = if cfg.lightTheme then "light" else "dark";
      altGtkThemeVariant = if cfg.lightTheme then "dark" else "light";

      tmuxShell = with pkgs; ''
        shell:
          working_directory: "$HOME"
          program: ${zsh}/bin/zsh
          args:
            - -i
            - -l
            - -c
            - "tmux new || tmux"
      '';

      zshShell = with pkgs; ''
        shell:
          working_directory: "$HOME"
          program: ${zsh}/bin/zsh
          args:
            - -i
            - -l
      '';

      configFile = shell: tFile: gtkTheme: op: ''
        import:
          - /home/twhitney/.config/alacritty/base.yml
          - /home/twhitney/.config/alacritty/${tFile}.yml

        ${shell}

        window:
          decorations: full
          dynamic_title: true
          gtk_theme_variant: ${gtkTheme}
          opacity: ${op}

        font:
          size: 12.0
      '';

      # Not sure if I still want a tmux shell
      localConfig = configFile zshShell;
      remoteConfig = configFile zshShell;
    in
    {
      programs.alacritty.enable  = true;
      xdg.configFile."alacritty/base.yml".source =
        "${dotfiles}/config/alacritty/base.yml";
      xdg.configFile."alacritty/gruvbox.yml".source =
        "${dotfiles}/config/alacritty/gruvbox.yml";
      xdg.configFile."alacritty/gruvbox-dark.yml".source =
        "${dotfiles}/config/alacritty/gruvbox-dark.yml";
      xdg.configFile."alacritty/solarized.yml".source =
        "${dotfiles}/config/alacritty/solarized.yml";
      xdg.configFile."alacritty/alacritty.yml".text =
        localConfig themeFile gtkThemeVariant opacity;
      xdg.configFile."alacritty/alacritty-alt.yml".text =
        localConfig altThemeFile altGtkThemeVariant opacity;
      xdg.configFile."alacritty/remote.yml".text =
        remoteConfig themeFile gtkThemeVariant opacity;
      xdg.configFile."alacritty/remote-alt.yml".text =
        remoteConfig altThemeFile altGtkThemeVariant opacity;
    };
}

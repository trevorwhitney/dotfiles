{
  config,
  pkgs,
  lib,
  ...
}:
let
  # K9s Solarized Light Skin Contributed by [@leg100](louisgarman@gmail.com)
  skin =
    let
      foreground = "#657b83";
      background = "#fdf6e3";
      current_line = "#eee8d5";
      selection = "#eee8d5";
      comment = "#93a1a1";
      cyan = "#2aa198";
      green = "#859900";
      yellow = "#b58900";
      orange = "#cb4b16";
      magenta = "#d33682";
      blue = "#268bd2";
      red = "#dc322f";
    in
    {
      k9s = {
        body = {
          fgColor = "${foreground}";
          bgColor = "${background}";
          logoColor = "${blue}";
        };
        prompt = {
          fgColor = "${foreground}";
          bgColor = "${background}";
          suggestColor = "${orange}";
        };
        info = {
          fgColor = "${magenta}";
          sectionColor = "${foreground}";
        };
        dialog = {
          fgColor = "${foreground}";
          bgColor = "${background}";
          buttonFgColor = "${foreground}";
          buttonBgColor = "${magenta}";
          buttonFocusFgColor = "white";
          buttonFocusBgColor = "${cyan}";
          labelFgColor = "${orange}";
          fieldFgColor = "${foreground}";
        };
        frame = {
          border = {
            fgColor = "${selection}";
            focusColor = "${foreground}";
          };
          menu = {
            fgColor = "${foreground}";
            keyColor = "${magenta}";
            numKeyColor = "${magenta}";
          };
          crumbs = {
            fgColor = "white";
            bgColor = "${cyan}";
            activeColor = "${yellow}";
          };
          status = {
            newColor = "${cyan}";
            modifyColor = "${blue}";
            addColor = "${green}";
            errorColor = "${red}";
            highlightcolor = "${orange}";
            killColor = "${comment}";
            completedColor = "${comment}";
          };
          title = {
            fgColor = "${foreground}";
            bgColor = "${background}";
            highlightColor = "${blue}";
            counterColor = "${magenta}";
            filterColor = "${magenta}";
          };
        };
        views = {
          charts = {
            bgColor = "default";
            defaultDialColors = [
              "${blue}"
              "${red}"
            ];
            defaultChartColors = [
              "${blue}"
              "${red}"
            ];
          };
          table = {
            fgColor = "${foreground}";
            bgColor = "${background}";
            cursorFgColor = "white";
            cursorBgColor = "${background}";
            markColor = "darkgoldenrod";
            header = {
              fgColor = "${foreground}";
              bgColor = "${background}";
              sorterColor = "${cyan}";
            };
          };
          xray = {
            fgColor = "${foreground}";
            bgColor = "${background}";
            cursorColor = "${current_line}";
            graphicColor = "${blue}";
            showIcons = false;
          };
          yaml = {
            keyColor = "${magenta}";
            colonColor = "${blue}";
            valueColor = "${foreground}";
          };
          logs = {
            fgColor = "${foreground}";
            bgColor = "${background}";
            indicator = {
              fgColor = "${foreground}";
              bgColor = "${selection}";
            };
          };
        };
      };
    };
in
{
  programs.k9s = {
    # inherit skin;
    enable = true;
  };
}

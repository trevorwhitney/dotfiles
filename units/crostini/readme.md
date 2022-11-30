# Terminal setup

1. Using the terminal preferences pane, set theme to `Solarized Light`
1. Got to: chrome-untrusted://terminal/html/nassh_preferences_editor.html
1. For "Text font family" enter: `"RobotoMono Nerd Font Mono", monospace`
1. For "Text font size" enter: `14` (changing this matters for some reason)
1. For  "Custom CSS (inline text)" enter
```css
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Bold Italic Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Bold Italic Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Bold Italic Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: italic;
    font-weight: 700;
}
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Bold Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Bold Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Bold Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: normal;
    font-weight: 700;
}
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Italic Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Italic Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Italic Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: italic;
    font-weight: 400;
}
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Light Italic Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Light Italic Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Light Italic Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: italic;
    font-weight: 300;
}
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Light Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Light Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Light Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: normal;
    font-weight: 300;
}
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Medium Italic Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Medium Italic Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Medium Italic Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: italic;
    font-weight: 500;
}
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Medium Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Medium Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Medium Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: normal;
    font-weight: 500;
}
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: normal;
    font-weight: 400;
}
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Thin Italic Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Thin Italic Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Thin Italic Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: italic;
    font-weight: 100;
}
@font-face {
    font-family: "RobotoMono Nerd Font Mono";
    src:    local(Roboto Mono Thin Nerd Font Complete Mono),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Thin Nerd Font Complete Mono.woff2") format("woff2"),
            url("https://mshaugh.github.io/nerdfont-webfonts/build/fonts/Roboto Mono Thin Nerd Font Complete Mono.ttf") format("truetype");
    font-stretch: normal;
    font-style: normal;
    font-weight: 100;
}
```

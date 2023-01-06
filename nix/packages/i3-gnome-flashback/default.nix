{ runCommand }: runCommand "i3-gnome-flashback" { src = ./src; } "cp -r $src $out"

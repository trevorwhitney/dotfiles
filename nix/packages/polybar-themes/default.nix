{ fetchFromGitHub, lib, runCommand }:
runCommand "polybar-themes"
{
  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "polybar-themes";
    rev = "4295e7e25dab2945913b48a50388dfbfdf13cd9c";
    sha256 = "sha256-VvjFHmq4x/ZqzKpgkeL/Hv07YH0DVEa2WZ0jsu9K11Y=";
  };
} "cp -r $src $out"

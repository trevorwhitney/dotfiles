final: prev: {
  kitty-themes =
    prev.kitty-themes.overrideAttrs (old: {
      version = "unstable-2022-08-11";

      src = prev.fetchFromGitHub {
        owner = "kovidgoyal";
        repo = old.pname;
        rev = "72cf0dc4338ab1ad85f5ed93fdb13318916cae14";
        sha256 = "d9mO2YqA7WD2dTPsmNeQg2dUR/iv2T/l7yxrt6WKX60=";
      };

      installPhase = ''
        mkdir -p $out/themes
        mv themes.json $out
        mv themes/*.conf $out/themes
      '';
    });
}

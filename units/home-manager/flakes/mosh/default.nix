{ pkgs ? import <nixpkgs> }:
pkgs.stdenv.mkDerivation rec {
  pname = "mosh";
  version = "1.3.2";

  src = pkgs.fetchFromGitHub {
    owner = "mobile-shell";
    repo = "mosh";
    rev = "dbe419d0e069df3fedc212d456449f64d0280c76";
    sha256 = "sha256-oQ0r1DezTnYHBQrk6u8jx4UOxQXvuzkzJ25S1n+auyY=";
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    makeWrapper
    perl
    pkg-config
    protobuf
  ];
  buildInputs = with pkgs; [
    bash-completion
    glibcLocales
    ncurses
    openssl
    perl
    protobuf
    zlib
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  patches = [
    ./ssh_path.patch
    ./mosh-client_path.patch
    # Fix build with bash-completion 2.10
    ./bash_completion_datadir.patch
  ];

  postPatch = with pkgs; ''
    substituteInPlace scripts/mosh.pl \
      --subst-var-by ssh "${openssh}/bin/ssh" \
      --subst-var-by mosh-client "$out/bin/mosh-client"
  '';

  configureFlags = [ "--enable-completion" ];

  postInstall = with pkgs; ''
    wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB;
    wrapProgram $out/bin/mosh-server --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive;
  '';

  CXXFLAGS = with pkgs; lib.optionalString stdenv.cc.isClang "-std=c++11";

  meta = with pkgs.lib; {
    homepage = "https://mosh.org/";
    description = "Mobile shell (ssh replacement)";
    longDescription = ''
      Remote terminal application that allows roaming, supports intermittent
      connectivity, and provides intelligent local echo and line editing of
      user keystrokes.

      Mosh is a replacement for SSH. It's more robust and responsive,
      especially over Wi-Fi, cellular, and long-distance links.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

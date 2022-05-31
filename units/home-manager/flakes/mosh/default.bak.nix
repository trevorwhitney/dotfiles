{ pkgs ? import <nixpkgs> }:

with pkgs;
stdenv.mkDerivation {
  name = "mosh";

  src = fetchFromGitHub {
    owner = "mobile-shell";
    repo = "mosh";
    rev = "dbe419d0e069df3fedc212d456449f64d0280c76";
    sha256 = "sha256-oQ0r1DezTnYHBQrk6u8jx4UOxQXvuzkzJ25S1n+auyY=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config makeWrapper ];
  buildInputs = [ protobuf ncurses zlib openssl ]
    ++ (with perlPackages; [ perl IOTty ]);
    /* ++ lib.optional withUtempter libutempter; */

  /* patches = [ ./ssh_path.patch ]; */

  preConfigurePhase = ''
    ./autogen.sh
  '';

  configureFlags = [ 
  "--enable-completion" 
  "--prefix=$out"
  ];
    /* ++ lib.optional withUtempter "--with-utempter"; */

  /* postPatch = '' */
  /*   substituteInPlace scripts/mosh.pl \ */
  /*       --subst-var-by ssh "${openssh}/bin/ssh" */
  /*   substituteInPlace scripts/mosh.pl \ */
  /*       --subst-var-by mosh-client "$out/bin/mosh-client" */
  /* ''; */

  postInstall = ''
    wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
    installShellCompletion --bash --name mosh.bash $out/bash-completion/completions/mosh
  '';

  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

  meta = with lib; {
    description = "Mosh fork with ssh-agent support";
    homepage = "https://github.com/Mic92/mosh";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

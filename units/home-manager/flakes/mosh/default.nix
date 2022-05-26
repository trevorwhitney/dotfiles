{ pkgs ? import <nixpkgs> }:

with pkgs;
stdenv.mkDerivation {
  name = "mosh";

  src = fetchFromGitHub {
    owner = "mobile-shell";
    repo = "mosh";
    rev = "dbe419d0e069df3fedc212d456449f64d0280c76";
    sha256 = "sha256-ULJSBFaVdjFmMS+kHV2/gM9YTr91mVwIhDOnH2UOViU=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config makeWrapper ];
  buildInputs = [ protobuf ncurses zlib openssl bash-completion ]
    ++ (with perlPackages; [ perl IOTty ])
    ++ lib.optional withUtempter libutempter;

  /* patches = [ ./ssh_path.patch ]; */

  configureFlags = [ "--enable-completion" ]
    ++ lib.optional withUtempter "--with-utempter";

  /* postPatch = '' */
  /*   substituteInPlace scripts/mosh.pl \ */
  /*       --subst-var-by ssh "${openssh}/bin/ssh" */
  /*   substituteInPlace scripts/mosh.pl \ */
  /*       --subst-var-by mosh-client "$out/bin/mosh-client" */
  /* ''; */

  postInstall = ''
    wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
  '';

  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

  meta = with lib; {
    description = "Mosh fork with ssh-agent support";
    homepage = "https://github.com/Mic92/mosh";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

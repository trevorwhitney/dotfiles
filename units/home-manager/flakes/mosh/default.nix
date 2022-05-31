{ pkgs ? import <nixpkgs> }:

with pkgs;
stdenv.mkDerivation rec {
  inherit pkgs;
  pname = "mosh";
  version = "1.3.2";

  src = lib.fetchFromGitHub {
    owner = "mobile-shell";
    repo = "mosh";
    rev = "dbe419d0e069df3fedc212d456449f64d0280c76";
    sha256 = "sha256-oQ0r1DezTnYHBQrk6u8jx4UOxQXvuzkzJ25S1n+auyY=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config makeWrapper protobuf perl ];
  buildInputs = [ protobuf ncurses zlib openssl bash-completion perl ];
    /* ++ lib.optional withUtempter libutempter; */

  strictDeps = true;

  enableParallelBuilding = true;

  patches = [
    ./ssh_path.patch
    ./mosh-client_path.patch
    ./utempter_path.patch
    # Fix w/c++17, ::bind vs std::bind
    (fetchpatch {
      url =
        "https://github.com/mobile-shell/mosh/commit/e5f8a826ef9ff5da4cfce3bb8151f9526ec19db0.patch";
      sha256 = "15518rb0r5w1zn4s6981bf1sz6ins6gpn2saizfzhmr13hw4gmhm";
    })
    # Fix build with bash-completion 2.10
    ./bash_completion_datadir.patch
  ];

  postPatch = ''
    # Fix build with Xcode 12.5 toolchain/case-insensitive filesystems
    # Backport of https://github.com/mobile-shell/mosh/commit/12199114fe4234f791ef4c306163901643b40538;
    # remove on next upstream release.
    patch -p0 < ${
      fetchpatch {
        url =
          "https://raw.githubusercontent.com/macports/macports-ports/70ca3f65e622c17582fd938602d800157ed951c3/net/mosh/files/patch-version-subdir.diff";
        sha256 = "1yyh6d07y9zbdx4fb0r56zkq9nd9knwzj22v4dfi55k4k42qxapd";
      }
    }

    substituteInPlace scripts/mosh.pl \
      --subst-var-by ssh "${openssh}/bin/ssh" \
      --subst-var-by mosh-client "$out/bin/mosh-client"
  '';

  configureFlags = [ "--enable-completion" ];
    /* ++ lib.optional withUtempter "--with-utempter"; */

  postInstall = ''
    wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
  '';

  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

  meta = with lib; {
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
    maintainers = with maintainers; [ viric SuperSandro2000 ];
    platforms = platforms.unix;
  };
}

{ lib, stdenv, fetchurl, xorg, imake, gccmakedep }:

stdenv.mkDerivation rec {
  pname = "x11-ssh-askpass";
  version = "1.2.4.1";

  outputs = [ "out" "man" ];

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-${version}.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-${version}.tar.gz";
    sha256 = "620de3c32ae72185a2c9aeaec03af24242b9621964e38eb625afb6cdb30b8c88";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ xorg.libX11 xorg.libXt xorg.libICE xorg.libSM ];

  configureFlags = [
    "--with-app-defaults-dir=$out/etc/X11/app-defaults"
  ];

  dontUseImakeConfigure = true;
  postConfigure = ''
    xmkmf -a
  '';

  installTargets = [ "install" "install.man" ];

  meta = with lib; {
    homepage = "https://github.com/sigmavirus24/x11-ssh-askpass";
    description = "Lightweight passphrase dialog for OpenSSH or other open variants of SSH";
    license = licenses.mit;
    platforms = platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}

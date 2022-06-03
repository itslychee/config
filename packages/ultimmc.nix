{ stdenv, lib, pkgs, qtbase, wrapQtAppsHook, makeWrapper, ...}:

stdenv.mkDerivation rec {
  name = "ultimmc";
  src = builtins.fetchTarball {
    url = "https://nightly.link/AfoninZ/UltimMC/actions/runs/2411672560/mmc-cracked-lin64.zip";
    sha256 = "1j7mm075i3a684fjflg5i5m2lf3zr9mhndkaaz619vwqznl5cpw0";
  };
  nativeBuildInputs = [ wrapQtAppsHook makeWrapper ];
  buildInputs = [ pkgs.coreutils ];
  installPhase = ''
    install -v -m555 -Dt$out/bin $src/bin/UltimMC
    install -v -m555 -Dt$out/bin $src/bin/*.so
  '';
  libs = lib.makeLibraryPath [ "${stdenv.cc.cc.lib}/lib" "${lib.getLib qtbase}/lib" "${lib.getLib pkgs.zlib}/lib"];
  postFixup = ''
    wrapProgram $out/bin/UltimMC \
      --set JAVA_HOME ${pkgs.jre} \
      --prefix LD_LIBRARY_PATH : ${libs}
  '';
}

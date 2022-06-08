{ stdenv, lib, pkgs, wrapQtAppsHook, autoPatchelfHook, makeWrapper, ...}:

stdenv.mkDerivation rec {
  name = "ultimmc";
  src = builtins.fetchTarball {
    url = "https://nightly.link/AfoninZ/UltimMC/actions/runs/2411672560/mmc-cracked-lin64.zip";
    sha256 = "1j7mm075i3a684fjflg5i5m2lf3zr9mhndkaaz619vwqznl5cpw0";
  };
  nativeBuildInputs = [ makeWrapper autoPatchelfHook wrapQtAppsHook ];
  buildInputs = with pkgs; [
    coreutils
    qt5.qtbase
    (lib.getLib stdenv.cc.cc.lib)
    (lib.getLib zlib)
  ];
  installPhase = ''
    install -v -m555 -Dt$out/bin $src/bin/UltimMC
    install -v -m555 -Dt$out/lib $src/bin/*.so
    install -v -m555 -Dt$out/bin/jars $src/bin/jars/*.jar
  '';
  # libs = lib.makeLibraryPath [ (lib.getLib stdenv.cc.cc.lib) (lib.getLib qtbase) (lib.getLib pkgs.zlib) ];
  postFixup = ''
    wrapProgram $out/bin/UltimMC \
      --add-flags "-d \$HOME/ultimmc" \
      --set JAVA_HOME ${pkgs.jre} \
      --prefix PATH : ${pkgs.jdk8}/bin
  '';
}

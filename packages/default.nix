{ pkgs, ...}:

with pkgs;
{
  ultimmc = libsForQt5.callPackage ./ultimmc.nix {};
}

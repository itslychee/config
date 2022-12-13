{ pkgs, ...}:
with pkgs.lib;
{
  nixpkgs.overlays = [
    (final: prev: {
      arc-theme = prev.arc-theme.overrideAttrs (old: {
        mesonFlags = old.mesonFlags ++ [
          "-Dtransparency=false"
        ];
      });
    })
  ];
}

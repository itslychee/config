{
  nixpkgs.overlays = [
    (_: prev: {
      arc-theme = prev.arc-theme.overrideAttrs (old: {
        mesonFlags = old.mesonFlags ++ [
          "-Dtransparency=false"
        ];
      });
    })
  ];
}

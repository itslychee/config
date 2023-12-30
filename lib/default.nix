{
  inputs,
  overlays ? [],
  modules ? [],
} @ attrs: let
  inherit (inputs.nixpkgs.lib) genAttrs;
in {
  each = f:
    genAttrs ["x86_64-linux" "aarch64-linux"] (system:
      f {
        inherit system;
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      });
  systems = import ./nixos.nix {inherit inputs overlays modules;};
}

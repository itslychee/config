{
  inputs,
  overlays ? [],
  modules ? [],
} @ attrs: let
  inherit (inputs.nixpkgs.lib) genAttrs;
in {
  eachSystem = genAttrs ["x86_64-linux" "aarch64-linux"];
  systems = import ./nixos.nix {inherit (attrs) inputs overlays modules;};
}

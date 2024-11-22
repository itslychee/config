{
  inputs = {
    nvim.url = "github:itslychee/nvim";
    colmena.url = "github:zhaofengli/colmena";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    conduwuit.url = "github:girlbossceo/conduwuit?ref=v0.4.6";
    nextcloud-caddy.url = "github:onny/nixos-nextcloud-testumgebung/56a5379b83ea9c03d4d16daf27ac91e1ba6b020f";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nextcloud-caddy.flake = false;
  };
  outputs =
    { nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      eachSystem =
        fun:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: fun nixpkgs.legacyPackages.${system});
    in
    {
      colmena = import ./hive.nix inputs;
      # adopt a pkgs/by-name approach but less intrusive 
      legacyPackages = eachSystem (
        pkgs:
        builtins.mapAttrs (
          name: _value:
          pkgs.callPackage ./pkgs/${name} {
            inherit inputs;
          }
        ) (lib.filterAttrs (_n: v: v == "directory") (builtins.readDir ./pkgs))
      );

    };
}

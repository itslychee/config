{
  inputs = {
    nvim.url = "github:itslychee/nvim";
    wire.url = "github:wires-org/wire";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    factorio.url = "github:MichailiK/nixpkgs/389365";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nextcloud-caddy.url = "github:onny/nixos-nextcloud-testumgebung/56a5379b83ea9c03d4d16daf27ac91e1ba6b020f";
    # nextcloud-caddy.flake = false;
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };
  outputs =
    {
      nixpkgs,
      colmena,
      ...
    }@inputs:
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

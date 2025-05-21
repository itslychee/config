{
  inputs = {
    nvim.url = "github:itslychee/nvim";
    wire.url = "github:wires-org/wire";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    factorio.url = "github:MichailiK/nixpkgs/389365";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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

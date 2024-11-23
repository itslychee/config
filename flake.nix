{
  inputs = {
    nvim.url = "github:itslychee/nvim";
    colmena.url = "github:zhaofengli/colmena";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    conduwuit.url = "github:girlbossceo/conduwuit?ref=v0.4.6";
    nextcloud-caddy.url = "github:onny/nixos-nextcloud-testumgebung/56a5379b83ea9c03d4d16daf27ac91e1ba6b020f";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    typhon.url = "github:itslychee/typhon?ref=itslychee/random-fixes-and-additions";
    nextcloud-caddy.flake = false;
  };
  outputs =
    {
      self,
      nixpkgs,
      typhon,
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

      typhonProject = typhon.lib.github.mkProject {
        owner = "itslychee";
        repo = "config";
        secrets = ./secrets.age;
        typhonUrl = "https://ci.wires.cafe";
        deploy = [
          {
            name = "Push to Attic";
            value = typhon.lib.attic.mkPush {
              endpoint = "https://cache.wires.cafe";
              cache = "lychee-config";
            };
          }
        ];
        meta = {
          description = "my nixos configuration";
        };
      };

      inherit self;
      typhonJobs.x86_64-linux = (colmena.lib.makeHive self.colmena).toplevel;

    };
}

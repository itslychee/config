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
      inherit (lib.fileset)
        fileFilter
        unions
        intersection
        difference
        toList
        ;

      eachSystem =
        fun:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: fun nixpkgs.legacyPackages.${system});
    in
    {
      colmena = {
        meta = {
          nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
          specialArgs = {
            inherit inputs;
          };
        };
        defaults =
          { name, config, ... }:
          {
            imports = toList (
              intersection (unions [
                ./hosts/${name}
                (difference ./modules ./modules/roles)
                # role definitions
                ./modules/roles/roles.nix
              ]) (fileFilter (p: p.hasExt "nix") ./.)
            );
            networking.hostName = name;
            users.users.root.openssh.authorizedKeys.keys = config.hey.keys.lychee.deployment;
            deployment.allowLocalDeployment = true;
            deployment.buildOnTarget = true;
          };

        hearth.imports = [
          ./modules/roles/graphical
        ];
        kaycloud.imports = [
          ./modules/roles/server
          ./modules/roles/s3
        ];
        rainforest-desktop.imports = [
          ./modules/roles/graphical
          ./modules/roles/server
        ];
        rainforest-node-1.imports = [
          ./modules/roles/server
          ./modules/roles/s3
        ];
        rainforest-node-2.imports = [
          ./modules/roles/server
          ./modules/roles/s3
        ];
        rainforest-node-3.imports = [
          ./modules/roles/server
          ./modules/roles/s3
        ];
        rainforest-node-4.imports = [
          ./modules/roles/server
          ./modules/roles/graphical
          ./modules/roles/s3
        ];
      };

      # adopt a pkgs/by-name approach but less intrusive 
      legacyPackages = eachSystem (
        pkgs:
        builtins.mapAttrs (
          name: value:
          pkgs.callPackage ./pkgs/${name} {
            inherit inputs;
          }
        ) (lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./pkgs))
      );

    };
}

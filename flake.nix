{
  inputs = {
    nvim.url = "github:itslychee/nvim";
    colmena.url = "github:zhaofengli/colmena";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    conduwuit.url = "github:girlbossceo/conduwuit?ref=v0.4.6";
    nextcloud-caddy.url = "github:onny/nixos-nextcloud-testumgebung/56a5379b83ea9c03d4d16daf27ac91e1ba6b020f";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nextcloud-caddy.flake = false;
    attic.url = "github:zhaofengli/attic";
  };
  outputs =
    {
      flake-parts,
      nixpkgs,
      ...
    }@inputs':
    let
      inherit (nixpkgs.lib) flatten mkOption;
      inherit (nixpkgs.lib.types)
        lazyAttrsOf
        raw
        attrsOf
        package
        ;
      inherit (nixpkgs.lib.fileset)
        toList
        difference
        unions
        intersection
        fileFilter
        ;
    in
    flake-parts.lib.mkFlake { inputs = inputs'; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports = flatten [
        # Load flakes
        (map (name: ./hosts/${name}/manifest.nix) (builtins.attrNames (builtins.readDir ./hosts)))
        {
          # copied from nixosConfigurations
          options.flake = flake-parts.lib.mkSubmoduleOptions {
            colmena = mkOption {
              type = lazyAttrsOf raw;
              default = { };
            };
            hydra = mkOption {
              type = attrsOf package;
            };
          };
        }
      ];

      flake =
        { lib, self', ... }:
        {
          colmena = {
            meta = {
              nixpkgs = inputs'.nixpkgs.legacyPackages.x86_64-linux;
              specialArgs = {
                inputs = inputs';
              };
              nodeNixpkgs.hellfire = inputs'.nixpkgs.legacyPackages.aarch64-linux;
            };
            defaults =
              {
                name,
                config,
                ...
              }:
              {
                imports = toList (
                  intersection (unions [
                    (difference ./hosts/${name} ./hosts/${name}/manifest.nix)
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
          };
          hydra = (inputs'.colmena.lib.makeHive inputs'.self.colmena).toplevel;
        };
    };
}

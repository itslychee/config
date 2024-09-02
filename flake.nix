{
  inputs = {
    nvim.url = "github:itslychee/nvim";
    colmena.url = "github:zhaofengli/colmena";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    conduwuit.url = "github:girlbossceo/conduwuit?ref=v0.4.6";
  };
  outputs = {
    flake-parts,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) flatten mkOption;
    inherit (nixpkgs.lib.types) lazyAttrsOf raw;
    inherit
      (nixpkgs.lib.fileset)
      toList
      difference
      unions
      intersection
      fileFilter
      ;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];
      imports = flatten [
        # Load flakes
        (map (name: ./hosts/${name}/manifest.nix) (builtins.attrNames (builtins.readDir ./hosts)))
        {
          # copied from nixosConfigurations
          options.flake = flake-parts.lib.mkSubmoduleOptions {
            colmena = mkOption {
              type = lazyAttrsOf raw;
              default = {};
            };
          };
        }
      ];

      flake.colmena = {
        meta = {
          nixpkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          specialArgs = {inherit inputs;};
        };
        defaults = {
          name,
          config,
          ...
        }: {
          imports = toList (intersection (unions [
            (difference ./hosts/${name} ./hosts/${name}/manifest.nix)
            (difference ./modules ./modules/roles)
            # role definitions
            ./modules/roles/roles.nix
          ]) (fileFilter (p: p.hasExt "nix") ./.));
          networking.hostName = name;
          users.users.root.openssh.authorizedKeys.keys = config.hey.keys.lychee.deployment;
          deployment.allowLocalDeployment = true;
          deployment.buildOnTarget = true;
        };
      };

      perSystem = {
        self',
        inputs',
        pkgs,
        lib,
        ...
      }: {
        packages.iso =
          (lib.nixosSystem {
            modules = [
              {
                nixpkgs.hostPlatform = pkgs.stdenv.system;
              }
              ./pkgs/iso
              inputs'.colmena.nixosModules.deploymentOptions
            ];
            specialArgs = {
              inherit inputs;
              # hack to make the modules behave with the out-of-hive module instance
              nodes = (inputs'.colmena.lib.makeHive self'.colmena).introspect ({nodes, ...}: nodes);
            };
          })
          .config
          .system
          .build
          .isoImage;
      };
    };
}

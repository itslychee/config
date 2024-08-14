{
  description = "the most powerful config ever to exist";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    colmena.url = "github:zhaofengli/colmena";
    spice.url = "github:Gerg-L/spicetify-nix";
    templates = {
      url = "github:itslychee/workflows";
      flake = false;
    };

    soteria.url = "github:ImVaskel/soteria";
    conduwuit.url = "github:girlbossceo/conduwuit/c29197b3";
    attic.url = "github:zhaofengli/attic";

    # mpdrp
    mpdrp.url = "github:itslychee/mpdrp";
    mpdrp.inputs.nixpkgs.follows = "nixpkgs";

    # home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    unstable,
    colmena,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs mkForce nixosSystem;
    inherit (nixpkgs.lib.fileset) toList unions fileFilter;

    each = f:
      genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (system: f nixpkgs.legacyPackages.${system});
  in {
    colmena = {
      meta = {
        nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
        nodeNixpkgs.hellfire = nixpkgs.legacyPackages.aarch64-linux;
        specialArgs = {inherit inputs;};
      };
      defaults = {
        name,
        config,
        ...
      }: {
        imports = toList (unions [
          (fileFilter (p: p.hasExt "nix") ./hosts/${name})
          ./modules
        ]);

        networking.hostName = name;
        users.users.root.openssh.authorizedKeys.keys = config.hey.keys.lychee.deployment;

        deployment = {
          allowLocalDeployment = true;
          buildOnTarget = true;
        };
      };
      # Hosts
      hellfire.deployment = {
        tags = ["servers"];
        allowLocalDeployment = mkForce false;
        buildOnTarget = mkForce false;
      };

      hearth.deployment.tags = ["server" "client"];
      pathway.deployment.tags = ["server"];
      wiretop.deployment = {
        tags = ["client"];
        buildOnTarget = mkForce false;
      };
      school-desktop.deployment.tags = ["client"];
      rainforest.deployment.tags = ["server"];
      kaycloud.deployment.tags = ["server"];
    };

    packages = each (pkgs: rec {
      iso =
        (nixosSystem {
          modules = [
            {
              nixpkgs.hostPlatform = pkgs.stdenv.system;
            }
            ./pkgs/iso
          ];
          specialArgs = {
            inherit inputs;
            # hack to make the modules behave with the out-of-hive module instance
            nodes = (colmena.lib.makeHive self.colmena).introspect ({nodes, ...}: nodes);
          };
        })
        .config
        .system
        .build
        .isoImage;
      nvim = inputs.unstable.legacyPackages.${pkgs.system}.callPackage ./pkgs/nvim.nix {};
      default = nvim;
    });

    devShells = each (pkgs: {
      default = pkgs.mkShell {
        packages = [pkgs.colmena];
      };
    });
  };
}

{
  description = "the most powerful config ever to exist";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    catppuccin.url = "github:catppuccin/nix";

    # agenix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";
    agenix.inputs.home-manager.follows = "";

    # wires bot
    wiresbot.url = "github:itslychee/wires-bot";

    # mpdrp
    mpdrp.url = "github:itslychee/mpdrp";
    mpdrp.inputs.nixpkgs.follows = "nixpkgs";

    # home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) flatten genAttrs nixosSystem;
    inherit (nixpkgs.lib.fileset) toList unions;
    imports = flatten [
      (toList (unions [./modules]))
      inputs.agenix.nixosModules.default
    ];

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
        # RPIs aren't x86_64-linux
        nodeNixpkgs.hellfire = nixpkgs.legacyPackages.aarch64-linux;

        specialArgs.inputs = inputs;
      };
      defaults = {name, ...}: {
        inherit imports;
        networking.hostName = name;
      };

      # Hosts
      pathway = {
        imports = [./hosts/pathway];
        deployment = {
          allowLocalDeployment = true;
          buildOnTarget = true;
        };
      };
      hellfire = {
        imports = [./hosts/hellfire];
        deployment.tags = ["servers" "always-on"];
      };
      hearth = {
        imports = [./hosts/hearth];
        deployment = {
          allowLocalDeployment = true;
          buildOnTarget = true;
          tags = ["servers" "always-on"];
        };
      };
      wirescloud = {
        imports = [./hosts/wirescloud];
        deployment = {
          buildOnTarget = true;
          tags = ["servers"];
        };
      };
    };

    packages = each (pkgs: {
      iso = nixosSystem {
        modules = flatten [
          imports
          ./hosts/iso
          {
            nixpkgs.hostPlatform = pkgs.stdenv.system;
            networking.hostName = "iso";
          }
        ];
        specialArgs.inputs = inputs;
      };
      nvim = pkgs.callPackage ./pkgs/nvim.nix {};
    });
  };
}

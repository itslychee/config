{
  description = "the most powerful config ever to exist";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    catppuccin.url = "github:catppuccin/nix";
    spice.url = "github:Gerg-L/spicetify-nix";

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
    inherit (nixpkgs.lib.fileset) toList;
    imports = flatten [
      (toList ./modules)
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
        nodeNixpkgs.hellfire = nixpkgs.legacyPackages.aarch64-linux;
        specialArgs = {inherit inputs;};
      };
      defaults = {name, ...}: {
        imports = imports ++ (toList ./hosts/${name});
        networking.hostName = name;
        hey.caps.rootLogin = true;
      };

      # Hosts
      hellfire.deployment.tags = ["servers" "always-on"];
      hearth.deployment = {
        allowLocalDeployment = true;
        buildOnTarget = true;
        tags = ["servers" "always-on"];
      };
      wirescloud.deployment = {
        buildOnTarget = true;
        tags = ["servers" "always-on"];
      };
      pathway.deployment = {
        allowLocalDeployment = true;
        buildOnTarget = true;
      };
    };

    packages = each (pkgs: {
      iso =
        (nixosSystem {
          modules = flatten [
            imports
            ./hosts/iso
            {
              nixpkgs.hostPlatform = pkgs.stdenv.system;
              networking.hostName = "iso";
            }
          ];
          specialArgs.inputs = inputs;
        })
        .config
        .system
        .build
        .isoImage;
      nvim = pkgs.callPackage ./pkgs/nvim.nix {};
    });

    devShells = each (pkgs: {
      default = pkgs.mkShell {
        packages = [
          pkgs.colmena
          inputs.agenix.packages.${pkgs.stdenv.system}.default
        ];
      };
    });
  };
}

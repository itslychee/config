{
  description = "the most powerful config ever to exist";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # zfs works here
    nixpkgs-zfs-ok.url = "github:NixOS/nixpkgs/2057814051972fa1453ddfb0d98badbea9b83c06";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    catppuccin.url = "github:catppuccin/nix";
    spice.url = "github:Gerg-L/spicetify-nix";

    # agenix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";
    agenix.inputs.home-manager.follows = "";

    # mpdrp
    mpdrp.url = "github:itslychee/mpdrp";
    mpdrp.inputs.nixpkgs.follows = "nixpkgs";

    # soteria
    soteria.url = "github:ImVaskel/soteria";
    soteria.inputs.nixpkgs.follows = "nixpkgs";

    # home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) flatten genAttrs mkForce nixosSystem;
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
    };

    packages = each (pkgs: {
      iso =
        (nixosSystem {
          modules = flatten [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ./pkgs/iso
            {
              inherit imports;
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

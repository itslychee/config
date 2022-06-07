{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };
  outputs = {self, nixpkgs, ... }@inputs: let
      mkConfig = hostname: {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          { nixpkgs.overlays = [ inputs.nur.overlay ]; }
          ./shared.nix
          ./system/${hostname}/configuration.nix
          ./system/${hostname}/hardware-configuration.nix
        ];
      };
      mkSystem = hostname: system: nixpkgs.lib.nixosSystem ((mkConfig hostname) // (system (mkConfig hostname)));
  in {
    nixosConfigurations = {
      kremlin = mkSystem "kremlin" (old: rec {
        modules = old.modules ++ [
          inputs.home-manager.nixosModules.home-manager {
             home-manager.backupFileExtension = "backup";
             home-manager.useGlobalPkgs = true;
             home-manager.useUserPackages = true;
             home-manager.verbose = true;
             home-manager.users.lychee = import ./home/lychee;
             home-manager.extraSpecialArgs = { hostname = "kremlin"; };
         }
        ];
      });
      laptop = mkSystem "laptop" (old: rec {
        modules = old.modules ++ [
          inputs.home-manager.nixosModules.home-manager {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.lychee = import ./home/lychee;
            home-manager.extraSpecialArgs = { hostname = "kremlin"; };
          }
        ];
      });
    };
  };
}

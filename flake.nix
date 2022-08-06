{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    pollymc.url = "github:fn2006/PollyMC";
  };
  outputs = {self, nixpkgs, home-manager, ... }@inputs: let
    mkSystemConfig = hostname: {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        { 
          nixpkgs.overlays = [ 
            inputs.nur.overlay
            inputs.pollymc.overlay
          ];
          nixpkgs.config.allowUnfree = true;
        }
        ./shared.nix
        ./system/${hostname}/configuration.nix
        ./system/${hostname}/hardware-configuration.nix
      ];
    };
    mkSystem = hostname: system: nixpkgs.lib.nixosSystem ((mkSystemConfig hostname) // (system (mkSystemConfig hostname)));
  in {
     nixosConfigurations.kremlin = mkSystem "kremlin" (old: {
       modules = old.modules ++ [
         home-manager.nixosModules.home-manager {
           home-manager.backupFileExtension = "backup";
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
	       home-manager.users.lychee = ./home/lychee;
           home-manager.verbose = true;
           home-manager.extraSpecialArgs = { inherit inputs; hostname = "kremlin"; };
         }
       ];
     });
     nixosConfigurations.laptop = mkSystem "laptop" (old: {
       modules = old.modules ++ [
         home-manager.nixosModules.home-manager {
           home-manager.backupFileExtension = "backup";
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.users.lychee = ./home/lychee;
           home-manager.verbose = true;
           home-manager.extraSpecialArgs = { inherit inputs; hostname = "laptop"; };
         }
       ];
     });
     nixosConfigurations.raspi = mkSystem "raspi" (old: {
       system = "aarch64-linux";
       modules = old.modules ++ [
         home-manager.nixosModules.home-manager {
           home-manager.backupFileExtension = "backup";
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.users.pi = ./home/pi;
           home-manager.verbose = true;
           home-manager.extraSpecialArgs = { inherit inputs; hostname = "raspi"; };
         }
       ];
     });
  };
}


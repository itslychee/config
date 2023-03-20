{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    agenix.url = "github:ryantm/agenix";
  };
  outputs = {
    self,
    utils,
    nixpkgs,
    home-manager,
    agenix,
    ...
  }@inputs: let
    mkSystem = {
      hostname,
      system ? "x86_64-linux",
      users,
      flags ? {}
    }@args: overrides: let
      mkConfig = {
        hostname,
        system ? "x86_64-linux",
        users,
        flags ? {}
      }: nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
         inherit hostname inputs flags; 
        };
        modules = [
          agenix.nixosModules.default
          ./hosts/${hostname}/configuration.nix
          ./hosts/${hostname}/hardware-configuration.nix
          ./mixins/nix.nix
          {
            nixpkgs.overlays = [
              (old: final: {
                unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
              })
            ];
            system.stateVersion = "22.11";
            services.dbus.enable = true;
          }
          home-manager.nixosModules.home-manager { 
            home-manager.verbose = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.sharedModules = [
              { home.stateVersion = "22.11"; }
            ];
            home-manager.users = users;
          }
        ];
      }; in (mkConfig args) // (overrides (mkConfig args)); 
  in {
    nixosConfigurations.embassy = mkSystem {
      hostname = "embassy";
      users = { lychee = ./home; };
    } (_: {});
    nixosConfigurations.cutesy = mkSystem {
      hostname = "cutesy";
      users = { lychee = ./home; };
      flags = {
        harden = true;
        headless = true;
      };
    } (_: {});
  };
}


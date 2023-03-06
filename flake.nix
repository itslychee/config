{
  description = "A very useless description here!";
  inputs = {
    # Packages
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
    # sops-nix.url = "github:Mic92/sops-nix";
    home-manager.url = "github:nix-community/home-manager";
    mc.url = "github:nix-community/mineflake";
  };
  outputs = {self, utils, nixpkgs, home-manager, ...}@inputs: let
    mkSystem = {hostname, system ? "x86_64-linux", users, flags ? {}}@args: overrides: let
      mkConfig = { hostname, system ? "x86_64-linux", users, flags ? {}}: nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
         inherit hostname inputs flags; 
        };
        modules = let
          version = "22.11";
        in [
          ./hosts/${hostname}/configuration.nix
          ./hosts/${hostname}/hardware-configuration.nix
          ./mixins/nix.nix
          {
            nixpkgs.overlays = [
              (old: final: {
                unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
              })
              inputs.mc.overlays.default
            ] ;
            system.stateVersion = version;
            services.dbus.enable = true;
          }
          home-manager.nixosModules.home-manager { home-manager = {
            verbose = true;
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            sharedModules = [ { home.stateVersion = version; } ];
            inherit users;
          }; }
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
        # harden reinforces the concept of security and hardens anything that makes for a more secure nix setup.
        harden = true;
        # headless removes the presence of GUI applications, which isn't necessary in server environments. 
        headless = true;
      };
    } (_: {});
  };
}


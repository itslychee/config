{ nixpkgs, hm, ...}@attrs:
with nixpkgs.lib; 
with builtins;
{
  # My hostnames are always going to be the same as <name> in
  # nixosConfigurations.<name> as it facilitates implicit nixos-rebuild
  # builds without me passing what config to use.
  systems = sys: 
    (mapAttrs (k: v: 
    (nixosSystem 
    ((removeAttrs (elemAt v 0) ["hostname" "headless"]) // (let
      self = (elemAt v 0);
    in rec {
        specialArgs = (self.specialArgs or {}) // { inherit self; };
        modules = (self.modules or []) ++ [
          ./options
          ../hosts/shared.nix
          hm.nixosModules.default
          { 
            networking.hostName = self.hostname;
            nixpkgs.hostPlatform = self.system; 
            system.stateVersion = "23.05";
            home-manager.verbose = true;
            home-manager.extraSpecialArgs = { headless = self.headless; };
            home-manager.useGlobalPkgs = true;
            home-manager.sharedModules = [ { home.stateVersion = "23.05"; } ];
          }
        ]; 
      }))
    ))
    (groupBy (v: v.hostname) sys));

  # Who knew flake-utils made a simple function look so complicated!?!!?
  eachSystem = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"];

}

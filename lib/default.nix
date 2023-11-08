{ nixpkgs, hm, master, ...}@attrs:
rec {
  # My hostnames are always going to be the same as <name> in
  # nixosConfigurations.<name> as it facilitates implicit nixos-rebuild
  # builds without me passing what config to use.
  systems = hosts: master.lib.attrsets.mergeAttrsList (nixpkgs.lib.forEach hosts 
  (host: {
    "${host.hostname}" = nixpkgs.lib.nixosSystem ((removeAttrs host [ "hostname" "headless"]) // {
        modules =[
        ./options
        ../hosts/shared.nix
        hm.nixosModules.home-manager
        {
          networking.hostName = host.hostname;
          nixpkgs.hostPlatform = host.system; 
          system.stateVersion = "23.05";
          home-manager.verbose = true;
          home-manager.extraSpecialArgs = { headless = host.headless; };
          home-manager.useGlobalPkgs = true;
          home-manager.sharedModules = [ { home.stateVersion = "23.05"; } ];
        }
      ];
      specialArgs = (host.specialArgs or {}) // { self = host; };
    });
  }));
  # Who knew flake-utils made a simple function look so complicated!?!!?
  eachSystem = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"];

}

{ 
  inputs,
  overlays ? [],
  modules ? [],
}:
let
  inherit (inputs.nixpkgs.lib)
    forEach
    attrsets
    nixosSystem
    genAttrs;
  inherit (inputs.hm.nixosModules) home-manager;
in {
  # My hostnames are always going to be the same as <name> in
  # nixosConfigurations.<name> as it facilitates implicit nixos-rebuild
  # builds without me passing what config to use.
  hosts =  hosts': 
    attrsets.mergeAttrsList
    (forEach hosts'
    (host: {
      ${host.hostname} = nixosSystem (
      (removeAttrs host [ "hostname" "headless" "overlays" "modules" ]
      ) // {
          modules = [
            ./options
            ../hosts/shared.nix
            home-manager
            {
              networking.hostName = host.hostname;
              home-manager.extraSpecialArgs = {
                inherit (host) headless;
                inherit inputs;
              };
              nixpkgs.hostPlatform = host.system; 
              nixpkgs.overlays = (host.overlays or []) ++ overlays;
            }
        ] ++ modules ++ host.modules;
        specialArgs = { self = host; inherit inputs; };
      });
    }));
}

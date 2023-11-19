{
  inputs,
  overlays ? [],
  defaultmodules ? [],
}:
let
  inherit (inputs.nixpkgs.lib)
    forEach
    attrsets
    nixosSystem
    genAttrs;
in 
{
  # My hostnames are always going to be the same as <name> in
  # nixosConfigurations.<name> as it facilitates implicit nixos-rebuild
  # builds without me passing what config to use.
  systems = hosts: 
  attrsets.mergeAttrsList
  (forEach hosts 
  (host: {
    ${host.hostname} = nixosSystem (
    (removeAttrs host [ "hostname" "headless" "overlays" "modules" ]
    ) // {
        modules = [
          ./options
          ../hosts/shared.nix
          {
            networking.hostName = host.hostname;
            home-manager.extraSpecialArgs.headless = host.headless;
            nixpkgs.hostPlatform = host.system; 
            nixpkgs.overlays = (host.overlays or []) ++ overlays;
          }
          inputs.hm.nixosModules.home-manager
      ] ++ defaultmodules ++ host.modules;
      specialArgs = { self = host; inherit inputs; };
    });
  }));
  # Who knew flake-utils made a simple function look so complicated!?!!?
  eachSystem = genAttrs ["x86_64-linux" "aarch64-linux"];

}

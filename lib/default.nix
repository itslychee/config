{ self, nixos-unstable, ...}@inputs:
let
  inherit (nixos-unstable.lib)
    genAttrs
    listToAttrs
    removeAttrs
    hasSuffix
    nixosSystem;
  inherit (builtins)
    pathExists;
in
rec {

  # Supported systems that I use, not just inside 
  # my configuration.
  per = genAttrs [
    "x86_64-linux"
    "aarch64-linux"
  ];

  mkImport = x: let
    qualifiedPath = 
      if (!pathExists x) && (!hasSuffix x ".nix")
      then
        "${x}.nix"
      else
        x;
    in import qualifiedPath inputs;

  mkSystems = hosts:
    listToAttrs (map 
      (v: {
        inherit (v) name;
        value = nixosSystem { 
          modules = [
            # Nixpkgs
            { 
              nixpkgs.hostPlatform = v.system;
              nixpkgs.overlays = [ (mkImport "${self}/overlays") ];
            }
            # Host
            (mkImport "${self}/hosts/${v.name}")
            # Module system
            (mkImport "${self}/modules")
            # Secrets
            (mkImport "${self}/secrets")
            # Flake modules
            inputs.agenix.nixosModules.agenix
            inputs.disko.nixosModules.disko

            (self.diskoConfigurations.${v.name} or {})
          ];
        };
      })
      hosts
    );

  mkDisko = hosts:
    listToAttrs (map 
      (name: {
        inherit name;
        value.disko.devices = mkImport ./hosts/${name}/disks;
      })
      hosts
    );
}

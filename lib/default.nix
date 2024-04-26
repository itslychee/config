{
  self,
  nixpkgs,
  ...
} @ inputs: let
  inherit
    (nixpkgs.lib)
    genAttrs
    optionals
    listToAttrs
    nixosSystem
    flatten
    ;
  inherit
    (nixpkgs.lib.fileset)
    toList
    unions
    ;
in rec {
  # Supported systems that I use throughout my daily life
  systems = ["x86_64-linux" "aarch64-linux"];
  per = genAttrs systems;
  nixpkgsPer = f: per (system: f nixpkgs.legacyPackages.${system});

  mkSystems = arch: hosts: (listToAttrs (
    map (name: {
      inherit name;
      value = mkSystem arch name;
    })
    hosts
  ));
  mkSystem = arch: hostname:
    nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = flatten [
        inputs.agenix.nixosModules.default
        {
          networking.hostName = hostname;
          nixpkgs.hostPlatform = arch;
        }
        # Module system
        (toList (unions [../modules]))
        # Host
        (import "${self}/hosts/${hostname}")
        (optionals (self.diskoConfigurations ? "${hostname}") [
          inputs.disko.nixosModules.disko
          self.diskoConfigurations.${hostname}
        ])
      ];
    };

  mkDisko = hosts:
    listToAttrs (map (name: {
        inherit name;
        value.disko.devices = import "${self}/hosts/${name}/disko.nix";
      })
      hosts);
}

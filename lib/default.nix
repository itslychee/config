{
  self,
  nixpkgs,
  disko,
  ...
} @ inputs: let
  inherit
    (nixpkgs.lib)
    genAttrs
    listToAttrs
    hasSuffix
    nixosSystem
    optionals
    flatten
    ;
  inherit
    (builtins)
    pathExists
    ;
in rec {
  # Supported systems that I use throughout my daily life
  systems = ["x86_64-linux" "aarch64-linux"];
  per = genAttrs systems;

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
        mylib = self.lib;
        inherit inputs;
      };
      modules = flatten [
        # Add disko configuration
        (optionals (self.diskoConfigurations ? "${hostname}") [
          self.diskoConfigurations.${hostname}
          disko.nixosModules.default
        ])
        {
          networking.hostName = hostname;
          # Nixpkgs
          nixpkgs.config.allowUnfree = true;
          nixpkgs.hostPlatform = arch;
        }
        # Host
        (import ../hosts/${hostname})
        # Module system
        (import ../modules)
      ];
    };

  mkDisko = hosts:
    listToAttrs (
      map
      (name: {
        inherit name;
        value = import ../hosts/${name}/disko.nix;
      })
      hosts
    );
}

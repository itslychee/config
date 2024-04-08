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
    mkForce
    ;
  inherit
    (nixpkgs.lib.fileset)
    toList
    unions
    difference
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
        inherit inputs;
      };
      modules = flatten [
        {
          hardware.enableAllFirmware = true;
          programs.command-not-found.enable = false;
          hey.nix.enable = true;
          networking = {
            useDHCP = mkForce false;
            hostName = hostname;
          };
          nixpkgs = {
            config.allowUnfree = true;
            hostPlatform = arch;
          };
        }
        # Module system
        (toList ( (unions [../modules ])))

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

{
  self,
  nixpkgs,
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
  per = genAttrs ["x86_64-linux" "aarch64-linux"];

  mkSystems = arch: hosts: (listToAttrs (
    map (name: {
      inherit name;
      value = nixosSystem {
        specialArgs = {
          mylib = self.lib;
          inherit inputs;
        };
        modules = flatten [
          {
            networking.hostName = name;
            # Nixpkgs
            nixpkgs.config.allowUnfree = true;
            nixpkgs.hostPlatform = arch;
          }
          # Host
          (import ../hosts/${name})
          # Module system
          (import ../modules/services)

          # Add disko configuration
          (optionals (self.diskoConfigurations ? name) [
            inputs.disko.nixosModules.disko
            self.diskoConfigurations.${name}
          ])
        ];
      };
    })
    hosts
  ));

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

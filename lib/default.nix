{
  self,
  nixos-unstable,
  ...
} @ inputs: let
  inherit
    (nixos-unstable.lib)
    genAttrs
    listToAttrs
    removeAttrs
    hasSuffix
    nixosSystem
    optional
    flatten
    ;
  inherit
    (builtins)
    pathExists
    ;
in rec {
  # Supported systems that I use throughout my daily life
  per = genAttrs ["x86_64-linux" "aarch64-linux"];

  mkImport = x: let
    qualifiedPath =
      if (!pathExists x) && (!hasSuffix x ".nix")
      then "${x}.nix"
      else x;
  in
    import qualifiedPath inputs;

  mkSystems = arch: hosts: (listToAttrs (
    map (name: {
      inherit name;
      value = nixosSystem {
        modules = flatten [
          {
            networking.hostName = name;

            # Nixpkgs
            nixpkgs.config.allowUnfree = true;
            nixpkgs.hostPlatform = arch;
            # nixpkgs.overlays = [(mkImport "${self}/overlays")];
          }
          # Host
          (mkImport "${self}/hosts/${name}")
          # Module system
          (mkImport "${self}/modules")
          # Secrets
          # Flake modules
          # inputs.agenix.nixosModules.agenix
          inputs.disko.nixosModules.disko

          # Add disko configuration
          (optional (self.diskoConfigurations ? name) self.diskoConfigurations.${name})
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
        value.disko.devices = mkImport ./hosts/${name}/disks;
      })
      hosts
    );
}

{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  isoConfig = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      inherit
        (
          ((import "${inputs.wire}/runtime/evaluate.nix") {
            path = inputs.self;
            hive = inputs.self.colmena;
          })
        )
        nodes
        ;
    };
    modules = lib.flatten [
      ./module.nix
      inputs.colmena.nixosModules.deploymentOptions
      { nixpkgs.hostPlatform = pkgs.system; }
    ];
  };
in
isoConfig.config.system.build.isoImage

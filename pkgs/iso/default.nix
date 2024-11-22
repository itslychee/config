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
      inherit (inputs.colmena.lib.makeHive inputs.self.colmena) nodes;
    };
    modules = lib.flatten [
      ./module.nix
      inputs.colmena.nixosModules.deploymentOptions
      { nixpkgs.hostPlatform = pkgs.system; }
    ];
  };
in
isoConfig.config.system.build.isoImage

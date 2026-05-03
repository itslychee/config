inputs:
let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs) lib;
  inherit (lib.fileset)
    fileFilter
    unions
    intersection
    difference
    toList
    ;
in
{
  meta = {
    nixpkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;

    };
    specialArgs = {
      inherit inputs;
    };
  };
  defaults =
    { name, config, ... }:
    {
      imports = toList (
        intersection (unions [
          ./hosts/${name}
          (difference ./modules ./modules/roles)
          # role definitions
          ./modules/roles/roles.nix
        ]) (fileFilter (p: p.hasExt "nix") ./.)
      );
      networking.hostName = name;
      users.users.root.openssh.authorizedKeys.keys = config.hey.keys.lychee.deployment;
      deployment.allowLocalDeployment = true;
      deployment.buildOnTarget = true;
    };

  hearth.imports = [
    ./modules/roles/graphical
    { system.stateVersion = "24.05"; }
  ];
  wiretop.imports = [
    ./modules/roles/graphical
    { system.stateVersion = "24.11"; }
  ];
  pathway.imports = [
    ./modules/roles/server
    { system.stateVersion = "23.11"; }
  ];
}

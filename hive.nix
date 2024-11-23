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
    nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
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
  kaycloud.imports = [
    ./modules/roles/server
    ./modules/roles/s3
    { system.stateVersion = "24.05"; }

  ];
  rainforest-desktop.imports = [
    ./modules/roles/graphical
    ./modules/roles/server
    { system.stateVersion = "24.05"; }
  ];
  rainforest-node-1.imports = [
    ./modules/roles/server
    ./modules/roles/s3
    { system.stateVersion = "24.05"; }
  ];
  rainforest-node-2.imports = [
    ./modules/roles/server
    ./modules/roles/s3
    { system.stateVersion = "24.05"; }
  ];
  rainforest-node-3.imports = [
    ./modules/roles/server
    ./modules/roles/s3
    { system.stateVersion = "24.05"; }
  ];
  rainforest-node-4.imports = [
    ./modules/roles/server
    ./modules/roles/graphical
    ./modules/roles/s3
    { system.stateVersion = "24.05"; }
  ];
  wiretop.imports = [
    ./modules/roles/graphical
    { system.stateVersion = "24.05"; }
  ];
}

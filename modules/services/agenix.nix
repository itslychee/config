{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [ inputs.agenix.nixosModules.default ];

  age.ageBin = lib.getExe pkgs.rage;
  age.secrets = {
    lychee-hearth.file = ../../secrets/lychee-hearth.age;
    pi-hellfire.file = ../../secrets/pi-hellfire.age;
  };

  # Add agenix tool
  environment.systemPackages = [
    (inputs.agenix.packages.${pkgs.system}.default.override {
      ageBin = (lib.getExe pkgs.rage);
    })
  ];
}

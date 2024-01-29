{
  pkgs,
  inputs,
  lib,
  ...
}: let
  ageBin = lib.getExe pkgs.rage;
in {
  imports = [inputs.agenix.nixosModules.default];

  # I want my system to reflect my configuration more
  users.mutableUsers = false;

  environment.systemPackages = [
    (inputs.agenix.packages.${pkgs.system}.default.override {
      inherit ageBin;
    })
  ];
  age.ageBin = ageBin;
}

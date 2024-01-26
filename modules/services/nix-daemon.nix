{
  config,
  pkgs,
  lib,
  inputs,
  mylib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in {
  options.hey.nix = {
    enable = mylib.mkDefaultOption;
  };
  config = mkIf config.hey.nix.enable {
    nix = {
      sshServe = {
        protocol = "ssh-ng";
        keys = inputs.self.publicSSHKeys;
        enable = true;
      };
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "hearth";
          systems = [ "x86_64-linux" "aarch64-linux" ];
          protocol = "ssh-ng";
          speedFactor = 10;
          maxJobs = 10;
          sshUser = "nix-builder";
        }
      ];
      settings = {
        trusted-users = [
          "@wheel"
          "root"
        ];
        builders-use-substitutes = true;
      };
    };

    users.users.nix-builder = {
      shell = pkgs.bash;
      isNormalUser = true;
      description = "remote builder";
    };

  };
}

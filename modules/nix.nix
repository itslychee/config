{
  config,
  pkgs,
  lib,
  inputs,
  mylib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.hey) nix;
in {
  options.hey.nix = {
    enable = mylib.mkDefaultOption;
    emulation = mylib.mkDefaultOption;
  };
  config = mkIf nix.enable {
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
          systems = ["x86_64-linux" "aarch64-linux"];
          protocol = "ssh-ng";
          speedFactor = 10;
          maxJobs = 10;
          sshUser = "nix-builder";
        }
        {
          hostName = "wirescloud";
          systems = ["x86_64-linux" "aarch64-linux"];
          protocol = "ssh-ng";
          speedFactor = 20;
          maxJobs = 20;
          sshUser = "nix-builder";
        }
      ];
      settings = {
        trusted-users = ["@wheel" "root"];
        builders-use-substitutes = true;
        use-xdg-base-directories = true;
        max-jobs = "auto";
        experimental-features = [
          "flakes"
          "nix-command"
          "no-url-literals"
          "repl-flake"
          "cgroups"
        ];
      };
    };

    boot.binfmt.emulatedSystems = mkIf nix.emulation [
      "aarch64-linux"
      "x86_64-linux"
    ];

    users.users.nix-builder = {
      shell = pkgs.bash;
      isNormalUser = true;
      description = "remote builder";
    };
  };
}

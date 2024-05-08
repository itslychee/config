{
  description = "the most powerful config ever to exist";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    deploy.url = "github:serokell/deploy-rs";

    # agenix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";
    agenix.inputs.home-manager.follows = "";

    # wires bot
    wiresbot.url = "github:itslychee/wires-bot";

    # mpdrp
    mpdrp.url = "github:itslychee/mpdrp";
    mpdrp.inputs.nixpkgs.follows = "nixpkgs";

    # home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    deploy,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) recursiveUpdate listToAttrs filterAttrs hasPrefix;
  in {
    lib = import ./lib inputs;
    nixosConfigurations =
      # Desktop
      self.lib.mkSystems "x86_64-linux" [
        "wirescloud"
        "hearth"
        "pathway"
      ]
      // self.lib.mkSystems "aarch64-linux" [
        "hellfire"
      ]
      // (listToAttrs (map (k: {
          name = "iso-${k}";
          value = self.lib.mkSystem k "iso";
        })
        self.lib.systems));

    deploy.nodes = builtins.mapAttrs (hostname: config: {
      inherit hostname;
      sshUser = "root";
      profiles.system = {
        user = "root";
        path = deploy.lib.${config.pkgs.stdenv.system}.activate.nixos config;
      };
    }) (filterAttrs (name: _: !hasPrefix "iso-" name) self.nixosConfigurations);

    formatter = self.lib.nixpkgsPer (pkgs: pkgs.alejandra);
    packages =
      recursiveUpdate
      # per system
      (self.lib.nixpkgsPer (pkgs: {
        iso = self.nixosConfigurations."iso-${pkgs.system}".config.system.build.isoImage;
        nvim = pkgs.callPackage ./pkgs/nvim.nix {};
      }))
      # specific
      {
        aarch64-linux.hellfire = self.nixosConfigurations.hellfire.config.system.build.sdImage;
      };

    devShells = self.lib.nixpkgsPer (pkgs: {
      default = pkgs.mkShell {
        packages = [
          inputs.agenix.packages.${pkgs.system}.default
          pkgs.deploy-rs
        ];
      };
    });
  };
}

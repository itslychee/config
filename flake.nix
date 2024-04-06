{
  description = "the most powerful config ever to exist";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    disko.url = "github:nix-community/disko";
    deploy.url = "github:serokell/deploy-rs";
    wiresbot.url = "github:itslychee/wires-bot";
    home-manager.url = "github:nix-community/home-manager";
  };
  outputs = {
    self,
    nixpkgs,
    deploy,
    ...
  } @ inputs: {
    lib = import ./lib inputs;
    nixosConfigurations =
      # Desktop
      self.lib.mkSystems "x86_64-linux" [
        "wirescloud"
        "wiretop"
        "hearth"
      ]
      // self.lib.mkSystems "aarch64-linux" [
        "hellfire"
      ]
      // (nixpkgs.lib.listToAttrs (map (k: {
          name = "iso-${k}";
          value = self.lib.mkSystem k "iso";
        })
        self.lib.systems));

    deploy.nodes = import ./deploy.nix {inherit inputs;};

    diskoConfigurations = self.lib.mkDisko ["wiretop"];

    formatter = self.lib.per (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      pkgs.writeShellApplication {
        runtimeInputs = builtins.attrValues {
          inherit (pkgs) gitFull;
          alejandra = pkgs.callPackage ./pkgs/alejandra.nix {};
        };
        name = "flake-formatter";
        text = ''
          if ! git diff --quiet; then
              echo "Dirty tree, exiting..."
              exit 1
          fi
          alejandra "$@"
          git commit -a -m "chore(alejandra): formatting (nix-fmt)"
        '';
      });
    packages = self.lib.per (system: rec {
      default = iso;
      iso = self.nixosConfigurations."iso-${system}".config.system.build.isoImage;
      hellfire = self.nixosConfigurations.hellfire.config.system.build.sdImage;
    });
  };
}

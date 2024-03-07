{
  description = "the most powerful config ever to exist";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    disko.url = "github:nix-community/disko";

    pr-wlscreenrec.url = "github:LudovicoPiero/nixpkgs?rev=84cd983e2136991313080480216413288b5398e3";
  };
  outputs = { self, nixpkgs, ... } @ inputs: {
    lib = (import ./lib inputs) // (import ./lib/types.nix inputs);
    nixosConfigurations =
      # Desktop
      self.lib.mkSystems "x86_64-linux" [
        "wirescloud"
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

    formatter = self.lib.per (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = self.lib.per (system: rec {
      default = iso;
      iso = self.nixosConfigurations."iso-${system}".config.system.build.isoImage;
      hellfire = self.nixosConfigurations.hellfire.config.system.build.sdImage;
    });
  };
}

{
  description = "the most powerful config ever to exist";
  inputs = {
    unstable.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    disko.url = "github:nix-community/disko";
    agenix.url = "github:ryantm/agenix";
  };
  outputs = {
    self,
    unstable,
    agenix,
    nixpkgs,
    nixos-hardware,
    disko,
    home-manager,
  } @ inputs: {
    lib = (import ./lib inputs) // (import ./lib/types.nix inputs);
    nixosConfigurations =
      # Desktop
      self.lib.mkSystems "x86_64-linux" ["hearth"]
      //
      # Raspberry Pi
      self.lib.mkSystems "aarch64-linux" ["hellfire"]
      //
      (nixpkgs.lib.listToAttrs (map (k: {
        name = "iso-${k}";
        value = self.lib.mkSystem k "iso"; 
      }) self.lib.systems));

    diskoConfigurations = self.lib.mkDisko ["hearth"];
    publicSSHKeys = import ./keys.nix;
    formatter = self.lib.per (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Doing it like this as I will never rebuild on an ISO and
    # this gives convenience when `nix build` is called
    packages = self.lib.per (system: rec {
      default = iso;
      iso = self.nixosConfigurations."iso-${system}".config;
    });
  };
}

{
  description = "the most powerful config ever to exist";
  inputs = {
    unstable.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    disko.url = "github:nix-community/disko";
    home-manager.url = "github:nix-community/home-manager";
  };
  outputs = {
    self,
    unstable,
    nixpkgs,
    nixos-hardware,
    disko,
    home-manager,
  } @ inputs: {
    lib = (import ./lib inputs) // (import ./lib/types.nix inputs);
    nixosConfigurations = 
      # Desktop
      self.lib.mkSystems "x86_64-linux" ["hearth"] //
      # Raspberry Pi
      self.lib.mkSystems "aarch64-linux" ["hellfire"];
    diskoConfigurations = self.lib.mkDisko [ "hearth" ];
    publicSSHKeys = [ 
        # Desktop
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHt4eGShEQs/nNwsHYbZDqOz9k1WVxDlJ4lJUfzosiG"
    ];
    formatter = self.lib.per (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}

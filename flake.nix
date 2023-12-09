{
  description = "the most powerful config ever to exist";
  inputs = {
    unstable.url = "github:NixOS/nixpkgs/master";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "unstable";
    };
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "unstable";
    };
  };
  outputs = {
    self,
    unstable,
    nixos-unstable,
    nixos-hardware,
    agenix,
    disko,
    wrapper-manager,
  } @ inputs: {
    lib = import ./lib inputs;
    nixosConfigurations = self.lib.mkSystems "x86_64-linux" ["hearth"];
    diskoConfigurations = self.lib.mkDisko [
      "hearth"
    ];
    publicSSHKeys = [
      {
        host = self.nixosConfigurations.embassy;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHt4eGShEQs/nNwsHYbZDqOz9k1WVxDlJ4lJUfzosiG";
      }
    ];
    formatter = self.lib.per (system: unstable.legacyPackages.${system}.alejandra);
  };
}

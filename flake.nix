{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;
    master.url = github:NixOS/nixpkgs;
    hm.url = github:nix-community/home-manager/release-23.05;
    mpdrp.url = github:itslychee/mpdrp;

    # Synchronize package collections
    hm.inputs.nixpkgs.follows = "nixpkgs";
    mpdrp.inputs.unstable-nixpkgs.follows = "master";
  };
  outputs = {self, nixpkgs, master, hm, mpdrp }@attrs: let
    # Overlays
    overlays = (final: prev: {
      unstable = import master { 
        system = prev.system;
        config.allowUnfree = true;
      };
    });
    # The only systems I'll be running with this flake.
    lib = (import ./lib attrs);
    # Default option
  in {
    # Hosts
    nixosConfigurations = (lib.systems [
      # Desktop
      {
        hostname = "hearth";
        system = "x86_64-linux";
        headless = false;
        modules = [
          ./hosts/hearth.nix
          { home-manager.users.lychee = ./home/lychee; }
          { nixpkgs.overlays = [ overlays ]; }
        ];
      }
    ]);
    # Formatter!
    formatter = lib.eachSystem (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt );
    # Templates
    templates = import ./templates attrs;
    };
}

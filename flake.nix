{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    master.url = github:NixOS/nixpkgs/master;
    hm.url = github:nix-community/home-manager/master;
    mpdrp.url = github:itslychee/mpdrp/rewrite;
    # mpdrp.url = path:/home/lychee/g/mpdrp;

    hm.inputs.nixpkgs.follows = "nixpkgs";
    mpdrp.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, nixpkgs, master, hm, mpdrp}@attrs: let
    lib = import ./lib {
      overlays = [
        (final: prev: {
          unstable = import master {
            system = prev.system;
            config.allowUnfree = true;
          };
        })
      ];
      # NixOS modules for all hosts
      defaultmodules = [
        { home-manager.sharedModules = [ mpdrp.nixosModules.default ]; }
      ];
      inputs = attrs;
    };
  in {
    nixosConfigurations = (lib.systems [
      {
        hostname = "hearth";
        system = "x86_64-linux";
        headless = false;
        modules = [
          { home-manager.users.lychee = ./home/lychee; }
          ./hosts/hearth.nix
        ];
        overlays = [
          (_: _: mpdrp.packages."x86_64-linux")
        ];
      }
    ]);
    # Formatter!
    formatter = lib.eachSystem (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt );
    # Templates
    templates = import ./templates attrs;
  };
}

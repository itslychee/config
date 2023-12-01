{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    master.url = path:/home/lychee/g/nixpkgs;
    # master.url = github:NixOS/nixpkgs/master;
    hm.url = github:nix-community/home-manager/master;
    mpdrp.url = github:itslychee/mpdrp/rewrite;
    # mpdrp.url = path:/home/lychee/g/mpdrp;

    hm.inputs.nixpkgs.follows = "nixpkgs";
    mpdrp.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    master,
    hm,
    mpdrp
  }@attrs: {
    # Personal library
    lib = import ./lib {
      overlays = [
        (final: prev: {
          unstable = import master {
            inherit (prev) system;
            config.allowUnfree = true;
          };
        })
      ];
      # NixOS modules for all hosts
      modules = [
        { home-manager.sharedModules = [ mpdrp.nixosModules.default ]; }
      ];
      inputs = attrs;
    };
    nixosConfigurations = self.lib.systems.hosts [
      {
        hostname = "hearth";
        system = "x86_64-linux";
        headless = false;
        modules = [
          { home-manager.users.lychee = ./home/lychee; }
          ./hosts/hearth.nix
        ];
        overlays = [ (_: _: mpdrp.packages."x86_64-linux") ];
      }
    ];
    # Templates
    templates = import ./templates attrs;
  };
}

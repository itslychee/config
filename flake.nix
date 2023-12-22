{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:itslychee/nixpkgs";
    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mpdrp.url = "github:itslychee/mpdrp/rewrite";
  };
  outputs = {
    self,
    nixpkgs,
    master,
    hm,
    mpdrp,
  } @ attrs: {
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
      modules = [{home-manager.sharedModules = [ mpdrp.homeManagerModules.default ];}];
      inputs = attrs;
    };
    nixosConfigurations = self.lib.systems.hosts [
      {
        hostname = "hearth";
        system = "x86_64-linux";
        headless = false;
        modules = [{home-manager.users.lychee = ./home/lychee;} ./hosts/hearth.nix];
      }
    ];
    # Templates
    templates = import ./templates attrs;
  };
}

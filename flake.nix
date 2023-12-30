{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mpdrp.url = "github:itslychee/mpdrp";
    spice.url = "github:Gerg-L/spicetify-nix";
    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    hm,
    mpdrp,
    ...
  } @ attrs: {
    # Personal library
    lib = import ./lib {
      # NixOS modules for all hosts
      modules = [
        {
          home-manager.sharedModules = [
            mpdrp.homeManagerModules.default
            attrs.spice.homeManagerModules.default
          ];
        }
      ];
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
    formatter = self.lib.each ({
      system,
      pkgs,
    }:
      pkgs.alejandra);
    # Templates
    templates = import ./templates attrs;
  };
}

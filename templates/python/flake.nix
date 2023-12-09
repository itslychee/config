{
  description = "My python project";
  inputs = {
    lib_.url = github:itslychee/config;
  };
  outputs = {
    self,
    nixpkgs,
    lib_,
  }: let
    inherit (lib_) lib;
  in {
    devShells = lib.eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          python311
          poetry
        ];
        shellHook = ''
          poetry env use python
        '';
      };
    });
  };
}

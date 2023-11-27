{
  description = "My python project";
  inputs = {
    poetry.url = github:nix-community/poetry2nix;
    lib.url = github:itslychee/config;
  };
  outputs = {
    nixpkgs,
    poetry,
    lib,
  }:
  {
    devShells = 
  };
}

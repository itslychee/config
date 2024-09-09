{
  flake.colmena.rainforest-desktop = {
    imports = [
      ../../modules/roles/graphical
      ../../modules/roles/server
      ../../modules/roles/s3
    ];
  };
}

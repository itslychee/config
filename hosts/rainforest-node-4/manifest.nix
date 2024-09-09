{
  flake.colmena.rainforest-node-4 = {
    imports = [
      ../../modules/roles/server

      ../../modules/roles/s3
    ];
  };
}

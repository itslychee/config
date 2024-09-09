{
  flake.colmena.rainforest-node-2 = {
    imports = [
      ../../modules/roles/server
      ../../modules/roles/s3
    ];
  };
}

{
  flake.colmena.rainforest-node-1 = {
    imports = [
      ../../modules/roles/server
      ../../modules/roles/s3
    ];
  };
}

{
  flake.colmena.kaycloud = {
    imports = [
      ../../modules/roles/server
      ../../modules/roles/s3
    ];
  };
}

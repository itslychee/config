{ lib, ... }:
{
  options.hey.roles = {
    graphical = lib.mkEnableOption "Graphical";
    server = lib.mkEnableOption "Headless";
    s3 = lib.mkEnableOption "S3";
  };
}

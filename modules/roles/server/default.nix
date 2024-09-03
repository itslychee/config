{lib, ...}: {
  imports = lib.fileset.toList (lib.fileset.difference ./. ./default.nix);
  deployment.tags = ["server"];
  hey.roles.server = true;
  boot.blacklistedKernelModules = ["uvcvideo"];
}

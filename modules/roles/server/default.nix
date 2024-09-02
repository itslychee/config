{
  deployment.tags = ["server"];
  hey.roles.server = true;
  boot.blacklistedKernelModules = ["uvcvideo"];
}

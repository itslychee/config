{ lib, ... }:
let
  inherit (lib) fileset;
in
{
  imports = fileset.toList (fileset.difference ./. ./default.nix);
  deployment.tags = [ "server" ];
  hey.roles.server = true;
  boot.blacklistedKernelModules = [ "uvcvideo" ];

  environment.sessionVariables.BROWSER = "echo ";

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
  systemd = {
    enableEmergencyMode = false;
    watchdog = {
      runtimeTime = "20s";
      rebootTime = "30s";
    };
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };
}

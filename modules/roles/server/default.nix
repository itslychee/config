{lib, ...}: let
  inherit (lib) mkDefault fileset;
in {
  imports = fileset.toList (fileset.difference ./. ./default.nix);
  deployment.tags = ["server"];
  hey.roles.server = true;
  boot.blacklistedKernelModules = ["uvcvideo"];

  environment.sessionVariables.BROWSER = "echo ";

  # Notice this also disables --help for some commands such es nixos-rebuild
  documentation = {
    enable = mkDefault false;
    info.enable = mkDefault false;
    man.enable = mkDefault false;
    nixos.enable = mkDefault false;
  };
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

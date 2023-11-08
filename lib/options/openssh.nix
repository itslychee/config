{ config, options, pkgs, ...}:
let
  cfg = config.servers.ssh;
in 
with pkgs.lib;
with builtins;
{
  options.servers.ssh = {
    enable = mkEnableOption "OpenSSH Server";
    allowedUsers = mkOption { type = types.listOf types.str; default = [];};
  };
  config.services.openssh = mkIf cfg.enable {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    extraConfig = ''
      AllowUsers ${concatStringsSep " " cfg.allowedUsers}
    '';
  };
}

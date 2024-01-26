{
  config,
  mylib,
  lib,
  ...
}:
let
  cfg = config.hey.sshServer;
in
{
  options.hey.sshServer = {
    enable = lib.mkEnableOption "OpenSSH Server";

  };
  config = lib.mkIf cfg.enable {
    # OpenSSH server
    services.openssh = {
      enable = true;
      banner = "woe to all who try to enter!\n";
      settings = {
        PasswordAuthentication = false;
      };
    };
    boot.initrd.network.ssh.enable = true;
  };

}

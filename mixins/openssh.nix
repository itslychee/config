{ allowedUsers ? []}:
{ pkgs, ...}:
with pkgs.lib;
{
  config.services.openssh = mkDefault {
   enable = true;
   settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
   };
   extraConfig = ''
     AllowUsers ${builtins.concatStringsSep " " allowedUsers}
   '';
  };
}

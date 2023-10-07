{ allowedUsers ? []}:
{ pkgs, ...}:
with pkgs.lib;
{
  config.services.openssh = mkOverride 100 {
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

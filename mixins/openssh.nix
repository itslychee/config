{ allowedUsers ? []}:
{ pkgs, ...}:
with pkgs.lib;
{
  config.services.openssh = mkDefault {
   enable = true;
   permitRootLogin = "no";
   passwordAuthentication = false;
   extraConfig = ''
     AllowUsers ${builtins.concatStringsSep " " allowedUsers}
   '';
  };
}
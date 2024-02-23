{ config,
 inputs,
 lib,
 pkgs,
 ...
}: let
  cfg = config.hey.ctx;
  inherit (lib) mkIf mkMerge;
in {
  age.secrets = {
    lychee-password.file = "${inputs.self}/secrets/lychee-password.age";
  };

  users.users.lychee = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = mkIf (builtins.elem cfg.platform [ "hybrid" "server"]) config.hey.keys.users.lychee;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.lychee-password.path;
  };
  hey.users.lychee = {
    wrappers.enable = true;
    packages = mkMerge [
      (builtins.attrValues {
        inherit (pkgs) 
          git
        ;
      })
      (mkIf (builtins.elem cfg.platform ["hybrid" "client"]) (builtins.attrValues {
        inherit (pkgs)
          firefox
          discord-canary
        ;
      }))
      
   ];
   wms.sway = mkIf (builtins.elem cfg.platform [ "hybrid" "client"]) {
     enable = true;
     keybindings = {
       "Mod4+Return" = lib.getExe pkgs.alacritty;
     };
   };
  };

}

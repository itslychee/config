{ osConfig, pkgs, lib, ...}:
let 
    inherit (lib) mkIf mkMerge optionals;
    is = osConfig.hey.caps;
in 
{
    home.packages = [] ++
       optionals is.graphical (builtins.attrValues {
           inherit (pkgs)
            anki
            discord-canary
           ;
       })
    ;
}

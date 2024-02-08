{ config, pkgs, lib, ...}:
let
  inherit (lib)
    mkOption
    mapAttrs'
    mapAttrsToList
    nameValuePair
  ;
  inherit (lib.types)
    attrsOf
    submodule
    path
    str
    bool
  ;

  fileType = submodule ({ name, config, ...}: {
    options = {
      source = mkOption { type = path; };
      text = mkOption { type = str; };
      executable = mkOption { type = bool; default = false; };
    };
  });

  userType = submodule ({ name, config, ...}: {
    options = {
      root = mkOption {
        type = attrsOf fileType;
      };
    };
  });


in 
{

  options.hey.users = mkOption { type = attrsOf userType; };

  # File management
  config.systemd.user.tmpfiles.users = mapAttrs' (k: v: nameValuePair
    k
    {
      rules = mapAttrsToList (name: value: 
      let
        file =
        if value.text != null then 
          pkgs.writeTextFile {
            name = "${k}-${name}-tmpfile";
            inherit (value) text executable;
          }  
        else
          value.source;
      in 
        "L+ %h/${name} - - - - ${file}"
      ) v.root;
    }
  ) config.hey.users;

}

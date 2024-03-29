{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (builtins) isString;
  inherit
    (lib)
    flatten
    mkOption
    mkMerge
    mkIf
    mapAttrsToList
    concatStringsSep
    mkEnableOption
    getExe
    ;
  inherit
    (lib.types)
    attrsOf
    listOf
    str
    package
    either
    lines
    bool
    ;
  sway = config.wms.sway;
  mako = config.programs.mako;
  waybar = config.programs.waybar;
in {
  options = {
    programs.mako = {
      enable = mkOption {
        type = bool;
        default = sway.enable;
      };
      settings = mkOption {
        type = lines;
        default = "";
      };
    };

    programs.waybar = {
      enable = mkOption {
        type = bool;
        default = sway.enable;
      };
    };

    wms.sway = {
      enable = mkEnableOption "Sway";
      keybindings = mkOption {
        type = attrsOf (either str package);
        default = {};
        apply = f: let
          keybinds = concatStringsSep "\n" (mapAttrsToList (
              name: value: let
                src =
                  if isString value
                  then value
                  else "exec ${getExe value}";
              in "  ${name} ${src}"
            )
            f);
        in ''
          bindsym {
          ${keybinds}
          }
        '';
      };
      autostart = mkOption {
        type = listOf (either str package);
        apply = f: ''
          exec_always {
          ${concatStringsSep "\n" (map (e:
            "  "
            + (
              if isString e
              then e
              else getExe e
            ))
          f)}
          }
        '';
      };
      extraConfig = mkOption {
        type = lines;
        default = "";
      };
    };
  };

  config = mkMerge [
    # Sway
    (mkIf sway.enable {
      switches.opengl = true;
      root.".config/sway/config".source = pkgs.writeText "home-sway" (concatStringsSep "\n" (flatten [
        "# Keybindings"
        sway.keybindings
        "# Autostart"
        sway.autostart
        "# extraConfig"
        sway.extraConfig
      ]));
      packages = [pkgs.swayfx pkgs.wl-clipboard];
    })
    (mkIf mako.enable {
      root.".config/mako/config".source = pkgs.writeText "home-mako" mako.settings;
      wms.sway.autostart = [pkgs.mako];
    })
    (mkIf waybar.enable {
      root = {
        ".config/waybar/config".source = ./config.json;
        ".config/waybar/style.css".source = ./style.css;
      };
      wms.sway.autostart = [ pkgs.waybar];
    })
  ];
}

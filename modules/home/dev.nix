{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.git;
  inherit (lib) mkOption mkEnableOption mkIf;
in {
  options = {
    programs.git = {
      enable = mkEnableOption "Git";
      extraConfig = mkOption {
        type = lib.types.raw;
        apply = lib.generators.toGitINI;
      };
    };
  };
  config = mkIf cfg.enable {
    root.".config/git/config".source = pkgs.writeText "home-git" cfg.extraConfig;
  };
}

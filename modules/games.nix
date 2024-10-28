{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.hey.graphical.games = lib.mkEnableOption "Games";
  config = lib.mkIf config.hey.graphical.games {
    environment.systemPackages = with pkgs; [
      heroic
      gamemode
      wineWowPackages.stable
    ];
    programs.steam.enable = true;
  };

}

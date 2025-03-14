{
  lib,
  pkgs,
  inputs,
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
    programs.steam = {
      enable = true;
      package = inputs.unstable.legacyPackages.${config.nixpkgs.hostPlatform.system}.steam;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      extraPackages = [ pkgs.gamescope ];
      protontricks.enable = true;
      gamescopeSession.enable = true;
    };
  };

}

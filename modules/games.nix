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
      gamemode
      wineWow64Packages.stable
    ];
    programs.steam = {
      enable = true;
      # FIXME: system has been renamed ... stdenv.hostPlatform.system
      package = inputs.unstable.legacyPackages.${config.nixpkgs.hostPlatform.system}.steam;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      extraPackages = [ pkgs.gamescope ];
      protontricks.enable = true;
      gamescopeSession.enable = true;
    };
  };

}

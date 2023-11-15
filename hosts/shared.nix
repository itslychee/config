# Shared nixos module among ALL hosts
{ pkgs, ...}:
{
  boot.tmp.useTmpfs = true;
  boot.tmp.cleanOnBoot = true;
  boot.tmp.tmpfsSize = "30%";
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = ["@wheel" "root" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc.persistent = true;
    gc.automatic = true;
    gc.options = "-d --delete-older-than 10d";
    gc.dates = "2d";
    optimise.automatic = true;
    optimise.dates = [ "weekly" ];
    channel.enable = false;
  };
  security.rtkit.enable = true;
  security.polkit.enable = true;


  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

}

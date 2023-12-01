# Shared nixos module among ALL hosts
{ pkgs, inputs, ...}:
{
  boot.tmp = {
    useTmpfs = true;
    cleanOnBoot = true;
    tmpfsSize = "30%";
  };
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = ["@wheel" "root" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    nixPath = [ 
      "nixpkgs=${inputs.nixpkgs}" 
      "localpkgs=/home/lychee/g/nixpkgs"
    ];
    gc.persistent = true;
    gc.automatic = true;
    gc.options = "-d --delete-older-than 10d";
    gc.dates = "2d";
    optimise.automatic = true;
    optimise.dates = [ "weekly" ];
  };
  security.rtkit.enable = true;
  security.polkit.enable = true;

  # nix-ld
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib fuse3 icu zlib
      nss openssl curl expat
    ];
  };
  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;
  # State version
  system.stateVersion = "23.05";
  home-manager.sharedModules = [ { home.stateVersion = "23.05"; } ];
  hardware.enableAllFirmware = true;
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

}

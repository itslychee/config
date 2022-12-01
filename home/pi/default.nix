{ pkgs, config, hostname, ...}@inputs:
{
  home.stateVersion = "22.11";
  imports = [
    ../lychee/neovim.nix
    ../lychee/utils.nix
    ../lychee/shell.nix
  ];
}

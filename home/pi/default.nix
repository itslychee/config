{ pkgs, config, hostname, ...}@inputs:
{
  imports = [
    ../lychee/neovim.nix
  ];
}

{ pkgs, config, hostname, ...}@inputs:
{
  imports = [
    ../lychee/neovim.nix
    ../lychee/utils.nix
  ];
  home.packages = with pkgs; [
    go_1_18
    rust-analyzer
  ];
}

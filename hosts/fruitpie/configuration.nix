{ config, pkgs, ...}:
{
  imports = [
    ../../mixins/security.nix
    (import ../../mixins/openssh.nix { allowedUsers = ["pi"]; })
  ];


  boot = {
    initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
    kernelParams = [ "console=ttyS1,115200n8" ];
    loader.grub.enable = false;
    loader.generic-extlinux-compatible = {
      enable = true;
      configurationLimit = 10;
    };
  };
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  users.users.pi = {
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [ ../../keys.pub ];
    shell = pkgs.zsh;
  };
}

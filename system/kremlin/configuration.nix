{ config, options, pkgs, ... }:
{
  imports = [
    ../../modules/system/pipewire.nix
    ../../modules/system/opengl.nix
    ../../modules/system/fonts.nix
    ../../modules/system/systemd-boot.nix
    ../../modules/system/networkmanager.nix
    ../../modules/system/xdg.nix
    ../../modules/system/gpg-agent.nix
  ];
  networking = {
    hostName = "kremlin";
    interfaces = {
      enp10s0.useDHCP = true;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 443 80 ];
      allowedUDPPorts = [ 443 80 ];
    };
  };

  services = {
    openssh.enable = true;
    blueman.enable = true;
  };

  security = {
    protectKernelImage = true;
    rtkit.enable = true;
    sudo.execWheelOnly = true;
  };

  console.earlySetup = true;

  # Programs
  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    pathsToLink = [ "/share/zsh" ];
  };

  users.users = {
    lychee = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };

  system.stateVersion = "22.05";
}


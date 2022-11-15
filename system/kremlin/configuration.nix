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
    ../../modules/system/gnome.nix
    ../../modules/system/swaylock.nix
    ../../modules/system/brightness.nix
    ../../modules/system/autofs.nix
  ];
  networking = {
    hostName = "kremlin";
    interfaces = {
      enp10s0.useDHCP = true;
    };
  };

  hardware.bluetooth.enable = true;
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

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-label/Storage";
    # I used Windows originally before making the full
    # switch to Nix-based system management. I have tons of
    # music on it and I should probably switch to something like
    # ZFS which is better suited for high volumes of data.
    fsType = "ntfs";
  };

  users.users = {
    lychee = {
      shell = pkgs.fish; 
      isNormalUser = true;
      openssh.authorizedKeys.keys = (import ../../misc/keys.nix).ssh;
      extraGroups = [ "audio" "wheel" "adbusers" "networkmanager" ]; # Enable ‘sudo’ for the user.
    };
  };
  programs.adb.enable = true;

  system.stateVersion = "22.05";
}


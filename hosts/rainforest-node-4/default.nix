{
  lib,
  config,
  pkgs,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAp0yi9vv/paF5cnqy5XhZl67z8Lv9qGWakrE6Zxijvf";
  };

  hey.users = {
    lychee.enable = lib.mkForce false;
    student = {
      enable = true;
      hashedPassword = "$y$j9T$i10ra0xsluldxL6/3Zq6e/$m28LXms.7W.XzBVjmXt5XPc/Kj8FrlH3wsu42Lzm1a2";
      sshKeys = config.hey.keys.lychee.ssh;
      groups = [
        "dialout"
        "wireshark"
      ];
      packages = [ pkgs.minicom ];
    };
  };
  programs.wireshark.enable = true;
  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 85;
  };
  hey.mine.use = true;

  services.consul.extraConfig.server = true;

  system.stateVersion = "24.05";
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "eno2" ];
  };
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}

{ inputs, lib, modulesPath, ...}: {


  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];


  boot.loader.systemd-boot.enable = true;
  hey.sshServer.enable = true;
  users.users = {
    hadock = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMefXB2y1fdobZGva3FEN/CDJxqu6JJmjNdKkQ/jMy/cAAAABHNzaDo="
      ];
    };
    lychee = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = inputs.self.publicSSHKeys;
      extraGroups = [ "wheel" ];
    };
  };

  # do not change
  system.stateVersion = "23.05";
}

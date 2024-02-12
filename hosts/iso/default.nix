{
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")
  ];
  # Documentation is not desired on ephemeral-like systems
  documentation.enable = lib.mkForce false;
}

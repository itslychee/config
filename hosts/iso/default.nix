{inputs, lib,...}: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
  ];
  # Documentation is not desired on ephemeral-like systems
  documentation.enable = lib.mkForce false;
}

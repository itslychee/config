_: {
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkMerge
    mkIf
    mkEnableOption
    ;
  cfg = config.hey.hardware;
in {
  options.hey.hardware = {
    cpu.amd = mkEnableOption "configure host for running on AMD CPUs";
  };
  config = mkMerge [
    (mkIf cfg.cpu.amd {
      # Enable KVM hypervisor for AMD
      boot.kernelModules = ["kvm-amd"];
      # Microcode updates
      hardware.cpu.amd.updateMicrocode = true;
    })
    {
      # No harm done right?
      hardware.enableRedistributableFirmware = true;
    }
  ];
}

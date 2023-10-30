# Shared nixos module among ALL hosts
{ pkgs, config, ... }:
{
  config = {
    boot.tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
      tmpfsSize = "30%";
    };

  };
}

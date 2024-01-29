# USELESS TYPES AAA
# USELESS TYPES AAA
# USELESS TYPES AAA
# USELESS TYPES AAA
# USELESS TYPES AAA
# USELESS TYPES AAA
# USELESS TYPES AAA
{nixpkgs, ...}: let
  inherit (nixpkgs.lib) mkOption types;
in {
  mkDefaultOption = mkOption {
    type = types.bool;
    default = true;
  };
}

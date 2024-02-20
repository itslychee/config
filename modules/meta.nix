{ lib, ...}:
# Provide context of a host
let
  inherit (lib) mkOption;
  inherit (lib.types) enum bool;
in
{
  # this is dumb but i also don't care about ur opinion <3
  options.hey.ctx = {
    # Not to be confused with lib.platforms, platform denotes what the host
    # is designed to be used as.
    platform = mkOption { type = enum [ "server" "client" "hybrid"]; };
    # Should the installation avoid adding any unnecessary packages?
    minimal = mkOption { type = bool; default = false; };


  };
}


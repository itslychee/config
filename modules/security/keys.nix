{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) attrsOf str listOf;
in
{
  options.hey.keys = mkOption {
    readOnly = true;
    description = "User keys";
    type = attrsOf (attrsOf (listOf str));
  };
  config.hey.keys = {
    lychee = {
      ssh = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcRclGevnYAIGPNsMrJ/kk2NaE3/HPtiFRnRY6FSMIR openpgp:0x6386F9F1"
      ];
      deployment = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcRclGevnYAIGPNsMrJ/kk2NaE3/HPtiFRnRY6FSMIR openpgp:0x6386F9F1"
      ];
    };
  };
}

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
    # me
    lychee =
      let
        hearthKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0oSTfGZYuBmADdQofLJm22dcIFAUaos048sayYp5/J";
      in
      {
        # "Tags" for finer permissions
        secrets = [ hearthKey ];
        ssh = [
          hearthKey
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXeFJBxjG2NgeKr4l58KIp7lPf/pUeYD/4bYVapuump phone"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILv8G52B8ANAEczyOLd6N15pmasoVde1I9pXajQOeUL5 openpgp:0xF2E43235"
        ];
        deployment = [
          hearthKey
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILv8G52B8ANAEczyOLd6N15pmasoVde1I9pXajQOeUL5 openpgp:0xF2E43235"
        ];
      };
  };
}

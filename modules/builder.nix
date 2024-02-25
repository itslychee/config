{
  config,
  lib,
  mylib,
  ...
}: let
  inherit (lib) mkMerge mkIf;
  cfg = config.hey.nix.builders;
  keys = config.hey.keys;
in {
  options.hey.nix.builders = {
    useBuilders = mylib.mkDefaultOptions;
    isBuilder = lib.mkEnableOption;
  };
  config = mkMerge [
    (mkIf cfg.isBuilder {
      services.openssh.extraConfig = ''
        Match User builder
          PermitTTY no
        	X11Forwarding no
        	PermitTunnel no
        	AllowTcpForwarding no
        	AllowAgentForwarding no
        Match All
      '';

      users.users.builder = {
        isSystemUser = true;
        openssh.authorizedKeys.keys = lib.flatten builtins.attrValues keys.privileged;
      };
    })
  ];
}

{
  inputs,
  config,
  lib,
  pkgs,
  ...
} @ attrs: {
  options.wrappers = lib.mkEnableOption "wrappers";
  config = {
    packages = [
      (import "${inputs.self}/modules/wrappers" {
        inherit pkgs lib inputs;
      })
    ];
  };
}

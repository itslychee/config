{
  linux_latest,
  lib,
  ...
}:
linux_latest.override {
  # https://github.com/NotAShelf/nyx/blob/d407b4d6e5ab7f60350af61a3d73a62a5e9ac660/hosts/enyo/kernel/packages/xanmod.nix#L21C18-L21C54
  enableCommonConfig = true;
  ignoreConfigErrors = true;
  structuredExtraConfig = let
    inherit (lib.kernel) yes no;
    inherit (lib) mkForce;
  in {
    CONFIG_NETDEVICES = mkForce yes;
  };
}

{ inputs, pkgs, ...}: 
(inputs.wrapper-manager.lib.build {
  inherit pkgs;
  modules = [
    ./nvim
  ];
})

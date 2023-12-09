_: {pkgs, ...}: {
  hey = {
    gui.all = true;
    hardware.cpu.amd = true;
    users = {
      lychee = {
        privileged = true;
        config = {pkgs, ...}: {
          home.packages = [
            pkgs.hello
          ];
        };
      };
    };
  };
}

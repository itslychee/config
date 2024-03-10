{
    security = {
        sudo = {
          execWheelOnly = true;
          extraConfig = ''
            Defaults pwfeedback
          '';
        };
        polkit.enable = true;
    };
}

{
    config = {
      security.sudo = {
          execWheelOnly = true;
          extraConfig = ''
            Defaults pwfeedback
          '';
      };
    };
}

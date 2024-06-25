{
  services.openssh = {
    authorizedKeysInHomedir = false;
    settings = {
      PasswordAuthentication = false;
    };
  };
}

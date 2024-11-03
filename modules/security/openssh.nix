{
  services.openssh = {
    authorizedKeysInHomedir = false;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
    };
  };
}

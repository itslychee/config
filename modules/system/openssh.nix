{ config, lib, ...}:
with lib;
{
  config = {
    services.openssh.enable = mkDefault true;
    services.openssh.authorizedKeysFiles = mkDefault [
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQDDa177v9bubNE98TLIqYbCNf8Uc7kyrBGIxSqKksi"
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxsk7CXGzb74/VgcDdax+migLka0muKNC6NH8g/QaBw"
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINPaOWJB8D5PImrtYLrA/phy9hKcEQCvmMDR993mOQoj"
    ];
    services.openssh.passwordAuthentication = mkDefault false;
    services.openssh.permitRootLogin = mkDefault "no";
  };
}

{pkgs, ...}: {
  environment.etc."gitconfig".text = ''
    [alias]
    l = "log --graph --all --oneline --decorate --pretty='format:%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
  '';
  environment.defaultPackages = [pkgs.git];
}

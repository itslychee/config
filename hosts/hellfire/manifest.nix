{ inputs, ... }:
{
  flake.colmena = {
    hellfire = {
      imports = [
        ../../modules/roles/server
      ];
      deployment = {
        allowLocalDeployment = false;
        buildOnTarget = false;
      };
    };
  };
}

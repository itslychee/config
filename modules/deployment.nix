{config, ...}: {
  users.users.root.openssh.authorizedKeys = config.hey.keys.users.lychee.deployment;
}

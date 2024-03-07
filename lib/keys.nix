let
  inherit (builtins) filter map getAttr;
in rec {
  filterKeys = attr: user: map (key: key.key) (filter (getAttr attr) user);
  all = map (k: k.key);
  privileged = filterKeys "privileged";
  encrypt = filterKeys "encrypt";
}

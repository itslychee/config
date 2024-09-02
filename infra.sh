#!/bin/sh
set -e

nodes=$(nix eval --apply 'with builtins; l: (filter (x: !elem x [ "defaults" "meta" "network" ])) (builtins.attrNames l)' --no-warn-dirty  --json .#colmena  | jq -r ".[]")
RESET="\e[0m"
GREEN="\e[32m"
MAGNETA="\e[35m"
LIGHTRED="\e[91m"


execute_command() {
    set +e
    ssh -o ConnectTimeout=5 root@"$1" -C "$2"
    set -e
}

for x in $nodes; do
    echo -e "$GREEN$x$RESET: running $MAGNETA$@$RESET"
    execute_command $x "$@"
done


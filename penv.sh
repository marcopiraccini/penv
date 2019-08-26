#!/bin/bash
#title        : penv.sh
#description  : Develop env docker-based
#========================================================

container_name=$(docker ps --format "{{.Names}}" | grep penv)
echo "Using container: $container_name"
SUDO=$(if docker info 2>&1 | grep "permission denied" >/dev/null; then echo "sudo -E"; fi)
socket=$($SUDO docker port $container_name 22)
port="$(echo "$socket" | cut -d':' -f2)"
sshArgs="$@ -Y -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p $port -i ~/.penv/penv-key"
ssh $sshArgs localhost

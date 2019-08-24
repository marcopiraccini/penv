#!/bin/bash
#title        :myenv.sh
#description  :Develop env docker-based
#========================================================

container_name=$(docker ps --format "{{.Names}}" | grep myenv)
echo "Using container: $container_name"
SUDO=$(if docker info 2>&1 | grep "permission denied" >/dev/null; then echo "sudo -E"; fi)
socket=$($SUDO docker port $container_name 22)
port="$(echo "$socket" | cut -d':' -f2)"
sshArgs="$@ -Y -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p $port -i ~/.myenv/myenv-key"
echo ssh $sshArgs localhost
ssh $sshArgs localhost


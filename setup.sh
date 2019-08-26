PENV_DIR=~/.penv
USER=`whoami`
USER_UID=`id -u`
USER_GUID=`id -g`
SUDO=$(if docker info 2>&1 | grep "permission denied" >/dev/null; then echo "sudo -E"; fi)

if [ ! -f $PENV_DIR/authorized_keys/authorized_keys ]; then
    mkdir -p $PENV_DIR/authorized_keys
    ssh-keygen -f $PENV_DIR/penv-key -t rsa -N ''
    cp $PENV_DIR/penv-key.pub $PENV_DIR/authorized_keys/authorized_keys
fi

mkdir -p temp
cp $PENV_DIR/authorized_keys/authorized_keys ./temp

echo "Adding env for user $USER with UID $USER_UID and GUID $USER_GUID"

$SUDO docker-compose stop
$SUDO docker-compose build --build-arg USER_ARG=$USER --build-arg USER_UID_ARG=$USER_UID --build-arg USER_GUID_ARG=$USER_GUID
$SUDO docker-compose up -d --force-recreate

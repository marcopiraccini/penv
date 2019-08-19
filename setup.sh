MYENV_DIR=~/.myenv
USER=`whoami`
USER_UID=`id -u`
USER_GUID=`id -g`
SUDO=$(if docker info 2>&1 | grep "permission denied" >/dev/null; then echo "sudo -E"; fi)

if [ ! -f $MYENV_DIR/authorized_keys/authorized_keys ]; then
    mkdir -p $MYENV_DIR/authorized_keys
    ssh-keygen -f $MYENV_DIR/myenv-key -t rsa -N ''
    cp $MYENV_DIR/myenv-key.pub $MYENV_DIR/authorized_keys/authorized_keys
fi

mkdir -p temp
cp $MYENV_DIR/authorized_keys/authorized_keys ./temp

echo "Adding env for user $USER with UID $USER_UID and GUID $USER_GUID"

$SUDO docker-compose stop 
$SUDO docker-compose build --build-arg USER_ARG=$USER --build-arg USER_UID_ARG=$USER_UID --build-arg USER_GUID_ARG=$USER_GUID 
$SUDO docker-compose up -d


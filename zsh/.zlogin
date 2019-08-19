# zsh startup

if [[ "$SSH_CONNECTION" != "" && "$MY_SSH_CONNECTION" != "yes" ]]; then
    while true; do
        echo -n "Do you want to attach to a tmux session? [y/n]"
        read yn
        case $yn in
            [Yy]* ) MY_SSH_CONNECTION="yes" tmux new-session -s development -A; break;;
            [Nn]* ) break;;
            * ) echo "Please answer y/n";;
        esac
    done
fi

# Add the host private key link
ln -s /run/secrets/host_ssh_key ~/.ssh/id_rsa 2> /dev/null
eval `ssh-agent -s` 2> /dev/null
ssh-add 2> /dev/null

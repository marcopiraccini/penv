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

# Ensure that we have an ssh config with AddKeysToAgent set to true
if [ ! -f ~/.ssh/config ] || ! cat ~/.ssh/config | grep AddKeysToAgent | grep yes > /dev/null; then
    echo "AddKeysToAgent  yes" >> ~/.ssh/config
fi
# Ensure a ssh-agent is running so you only have to enter keys once
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

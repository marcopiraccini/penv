FROM phusion/baseimage:master

LABEL Maintainer="Marco Piraccini <marco.piraccini@gmail.com>"

# Required for phusion, modifies PID 1
CMD ["/sbin/my_init"]

# Docker file params: the user (name , uid, guid) to be used.
ARG USER_ARG
ARG USER_UID_ARG
ARG USER_GUID_ARG

ENV USER=$USER_ARG
ENV USER_UID=$USER_UID_ARG
ENV USER_GUID=$USER_GUID_ARG

# LANG config
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# For tmux
ENV TERM xterm-256color
# Configurable user home
ENV USER_HOME=/home/$USER
# This stops us from getting spammed about "missing frontend"
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Basic packages
RUN apt-get update && apt-get install -y              \
                          software-properties-common  \
                          curl                        \
                          x11-apps                    \
                          apt-utils                   \
                          zsh                         \
                          curl                        \
                          git                         \
                          sudo                        \
                          wget                        \
                          fontconfig                  \
                          mosh                        \
                          fonts-powerline             \
                          htop                        \
                          build-essential             \
                          python3-pip                 \
                          locales                     \
                          xclip                       \
                          xauth                       \
                          htop                        \
                          bash                        \
                          python-dev                  \
                          python-pip                  \
                          python3-dev                 \
                          python3-pip                 \
                          ctags                       \
                          shellcheck                  \
                          netcat                      \
                          ack-grep                    \
                          sqlite3                     \
                          unzip                       \
                          libssl-dev                  \
                          libffi-dev                  \
                          locales                     \
                          cmake                       \
                          ca-certificates             \
                          fakeroot                    \
                          gconf2                      \
                          gconf-service               \
                          gvfs-bin                    \
                          libasound2                  \
                          libcap2                     \
                          libgconf-2-4                \
                          libgcrypt20                 \
                          libgtk2.0-0                 \
                          libgtk-3-0                  \
                          libnotify4                  \
                          libnss3                     \
                          libx11-xcb1                 \
                          libxkbfile1                 \
                          libxss1                     \
                          libxtst6                    \
                          libgl1-mesa-glx             \
                          libgl1-mesa-dri             \
                          xdg-utils

#########################################################################
# UNIX CONFIG
#########################################################################

# Tmux makes our life difficult, set all of this stuff
RUN echo "export TERM=xterm-256color" >> /etc/zsh/zprofile
RUN echo "export USER_HOME=${USER_HOME}" >> /etc/zsh/zprofile
RUN echo "export LC_ALL=en_US.UTF-8" >> /etc/zsh/zprofile

# Make sshd directory accessible as non-root user
RUN chmod 0755 /var/run/sshd
# Disable password based authentication with ssh
RUN sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/' /etc/ssh/sshd_config
# We want X11 features via ssh (for graphical display, clipboard etc)
RUN sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config
# We should be able to send custom env vars
RUN sed -i 's/#PermitUserEnvironment no/PermitUserEnvironment yes/' /etc/ssh/sshd_config

# Enable ssh with phusion (https://github.com/phusion/baseimage-docker#enabling-ssh)
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# We don't want to run as root even inside our container
RUN groupadd -g $USER_GUID $USER
RUN useradd -rm -d $USER_HOME -s /usr/bin/zsh -g $USER_GUID -G sudo -u $USER_UID $USER -p '*'
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN runuser -l $USER -c 'mkdir -p $USER_HOME/.ssh'

# Now that we have our user, we install what we need ################################################
USER $USER

# TMUX (built from source)
ADD ./tmux/install_tmux.sh $USER_HOME
RUN sudo $USER_HOME/install_tmux.sh && sudo rm -f $USER_HOME/install_tmux.sh

# Docker
RUN sudo apt-get update
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN sudo apt-get update
RUN sudo apt-get install -y docker-ce docker-ce-cli containerd.io
RUN sudo usermod -aG docker $USER

# Atom
ENV ATOM_VERSION "v1.40.0"
RUN curl -L https://github.com/atom/atom/releases/download/${ATOM_VERSION}/atom-amd64.deb > /tmp/atom.deb
RUN sudo dpkg -i /tmp/atom.deb
RUN rm -f /tmp/atom.deb
ADD ./atom/atom-packages-list.txt $USER_HOME
RUN apm install --packages-file $USER_HOME/atom-packages-list.txt
RUN sudo rm $USER_HOME/atom-packages-list.txt

# Neovim + plug
RUN sudo add-apt-repository ppa:neovim-ppa/stable
RUN sudo apt-get update && sudo apt-get install -y neovim

# NVM and node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
RUN /bin/bash -c "source ~/.nvm/nvm.sh; nvm install 10; nvm use 10"

# oh_my_zsh + spaceship theme
# NOTE: we migth want to move this outside the base image and setup when creating
# the container.
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt
RUN ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme


# Copy all config
COPY ./zsh/* $USER_HOME/
COPY ./vim/init.vim $USER_HOME/.config/nvim/
COPY ./tmux/.tmux.conf $USER_HOME/.tmux.conf
COPY ./atom/config.cson $USER_HOME/.atom/

# Set correct ownership
RUN sudo chown -R $USER:$USER $USER_HOME

# Setup SSH access
COPY ./temp/authorized_keys /tmp/your_key.pub
RUN cat /tmp/your_key.pub >> $USER_HOME/.ssh/authorized_keys && sudo rm -f /tmp/your_key.pub
RUN chmod 700 $USER_HOME/.ssh
RUN chmod 600 $USER_HOME/.ssh/authorized_keys

USER root
SHELL ["/usr/bin/zsh", "-c"]
RUN apt-get clean && apt-get autoclean && apt-get autoremove

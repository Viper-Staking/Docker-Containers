FROM debian:latest
LABEL maintainer="VIPER Staking Team (viperstakepool@gmail.com)"

RUN apt-get update \
 && apt-get install -y \
    zsh \
    wget \
    git \
    npm \
    vim \
    tmux \
    python3 \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*

# Setup default user environment
ARG USERNAME="lovelace"
ARG USERID="1000"
ARG GROUPID="1024"
RUN groupadd -g $GROUPID -r $USERNAME \
 && useradd --no-log-init -r --gid $GROUPID -u $USERID $USERNAME \
 && mkdir /home/$USERNAME
COPY ./shared-terminal-settings/dotfiles /home/${USERNAME}/dotfiles
COPY ./zshrc /home/${USERNAME}/.zshrc
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} \
 && chown -R ${USERNAME}:${USERNAME} /usr/local \
 && echo ${USERNAME}:${USERNAME} | chpasswd \
 && chsh -s /usr/bin/zsh ${USERNAME}
USER ${USERNAME}

# Install and setup environment for default user
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
 && ln -s /home/${USERNAME}/dotfiles/tmux-shared /home/${USERNAME}/.tmux.conf \
 && ln -s /home/${USERNAME}/dotfiles/vimrc-shared /home/${USERNAME}/.vimrc \
 && mkdir -p /home/${USERNAME}/.vim/colors \
 && cp /home/${USERNAME}/dotfiles/monokai.vim /home/${USERNAME}/.vim/colors \
 && git clone https://github.com/scrooloose/nerdtree.git /home/${USERNAME}/.vim/bundle/nerdtree \
 && npm install -g spaceship-prompt \
 && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
 && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
 && vim +PluginInstall +qall

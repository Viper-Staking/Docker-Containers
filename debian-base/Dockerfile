from debian:latest

RUN apt-get update \
  && apt-get upgrade -y \
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
RUN groupadd -r debian \
  && useradd --no-log-init -r -g debian debian \
  && mkdir /home/debian
COPY ./shared-terminal-settings/dotfiles /home/debian/dotfiles
COPY ./zshrc /home/debian/.zshrc
RUN chown -R debian:debian /home/debian \
  && chown -R debian:debian /usr/local \
  && echo debian:debian | chpasswd \
  && chsh -s /usr/bin/zsh debian
USER debian

# Install and setup environment for default user
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  && ln -s /home/debian/dotfiles/tmux-shared /home/debian/.tmux.conf \
  && ln -s /home/debian/dotfiles/vimrc-shared /home/debian/.vimrc \
  && mkdir -p /home/debian/.vim/colors \
  && cp /home/debian/dotfiles/monokai.vim /home/debian/.vim/colors \
  && git clone https://github.com/scrooloose/nerdtree.git /home/debian/.vim/bundle/nerdtree \
  && npm install -g spaceship-prompt \
  && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

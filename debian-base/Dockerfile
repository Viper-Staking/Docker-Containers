from debian:latest

RUN apt update -y
RUN apt install zsh wget git npm vim tmux python3 python3-pip -y

# Setup default user environment
RUN groupadd -r debian && useradd --no-log-init -r -g debian debian
RUN mkdir /home/debian
COPY ./shared-terminal-settings/dotfiles /home/debian/dotfiles
COPY ./zshrc /home/debian/.zshrc
RUN chown -R debian:debian /home/debian
RUN chown -R debian:debian /usr/local
RUN echo debian:debian | chpasswd
RUN chsh -s /usr/bin/zsh debian
USER debian

# Install and setup environment for default user
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN ln -s /home/debian/dotfiles/tmux-shared /home/debian/.tmux.conf
RUN ln -s /home/debian/dotfiles/vimrc-shared /home/debian/.vimrc
RUN mkdir -p /home/debian/.vim/colors
RUN cp /home/debian/dotfiles/monokai.vim /home/debian/.vim/colors
RUN git clone https://github.com/scrooloose/nerdtree.git /home/debian/.vim/bundle/nerdtree
RUN npm install -g spaceship-prompt
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

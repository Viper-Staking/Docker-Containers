FROM debian:latest
MAINTAINER VIPER Staking Team (viperstakepool@gmail.com)

# Update and install the required packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  build-essential \
  pkg-config \
  libffi-dev \
  libgmp-dev \
  libssl-dev \
  libtinfo-dev \
  libsystemd-dev \
  zlib1g-dev \
  make \
  g++ \
  tmux \
  git \
  jq \
  wget \
  libncursesw5 \
  libtool \
  autoconf

WORKDIR /opt

# Build and install the IOHK fork of libsodium.
RUN git clone https://github.com/input-output-hk/libsodium \
  && cd libsodium \
  && git checkout 66f017f1 \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Install cabal
RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
  && tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
  && rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig \
  && mv cabal /usr/local/bin/

# Install GHC
RUN wget https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb9-linux.tar.xz \
  && tar -xf ghc-8.6.5-x86_64-deb9-linux.tar.xz \
  && rm ghc-8.6.5-x86_64-deb9-linux.tar.xz \
  && cd ghc-8.6.5 \
  && ./configure \
  && make install \
  && cabal update 

# Install cardano node
ARG TAG=1.15.1
RUN git clone https://github.com/input-output-hk/cardano-node.git \
  && cd cardano-node \
  && git fetch --all --tags \
  && git checkout tags/$TAG \
  && cabal install cardano-node cardano-cli

# Build the final stage and copy the build artifacts from the previous stage.
FROM debian:buster-slim
COPY --from=0 /usr/local/lib/libsodium* /usr/local/lib/
COPY --from=0 /root/.cabal/bin/cardano-cli /usr/local/bin/
COPY --from=0 /root/.cabal/bin/cardano-node /usr/local/bin/
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Run the package updates and installs if needed.
RUN apt-get update && apt-get upgrade -y \
  && rm -rf /var/lib/apt/lists/*

# Setup the user and group for shared folders.
ARG USERNAME="lovelace"
ARG USERID="1000"
ARG GROUPID="1024"
RUN groupadd -g $GROUPID -r $USERNAME \
  && useradd --no-log-init -r --gid $GROUPID -u $USERID $USERNAME \
  && mkdir /home/$USERNAME \
  && chown -R ${USERNAME}:${GROUPID} /home/${USERNAME} \
  && echo ${USERNAME}:lovelace | chpasswd
USER ${USERNAME}

# Create a directory for the node config files and blockchain database. 
# This needs to be mounted to a host volume on container run.
RUN mkdir $HOME/cardano-node/
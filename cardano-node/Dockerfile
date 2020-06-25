FROM debian:latest
# FROM registry.gitlab.com/viper-staking/docker-containers/debian-base:latest
MAINTAINER VIPER Staking Team (viperstakepool@gmail.com)

# Update and install the required packages
RUN apt-get update && apt-get install -y \
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
  libncursesw5

WORKDIR /home 

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
RUN git clone https://github.com/input-output-hk/cardano-node.git \
  && cd cardano-node \
  && git fetch --all --tags \
  && git checkout tags/1.14.1 \
  && cabal install cardano-node cardano-cli

# Create node directories and download config files
RUN mkdir node && cd node \
  && wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/shelley_testnet-config.json \
  && wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/shelley_testnet-genesis.json \
  && wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/shelley_testnet-topology.json \
  && mkdir db && touch db/node.socket


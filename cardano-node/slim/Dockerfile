FROM debian:latest AS build
LABEL maintainer="VIPER Staking Team (viperstakepool@gmail.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  automake \
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
  autoconf \
  curl

# Build and install the IOHK fork of libsodium.
WORKDIR /opt
RUN git clone https://github.com/input-output-hk/libsodium \
  && cd libsodium \
  && git checkout 66f017f1 \
  && ./autogen.sh \
  && ./configure \
  && make -j16 \
  && make install
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Install cabal
WORKDIR /opt
RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.4.1.0/cabal-install-3.4.1.0-x86_64-linux-deb10.tar.xz \
  && tar -xf cabal-install-3.4.1.0-x86_64-linux-deb10.tar.xz \
  && rm cabal-install-3.4.1.0-x86_64-linux-deb10.tar.xz \
  && mv cabal /usr/local/bin/ \
  && cabal update

# Install GHC
WORKDIR /opt
RUN wget https://downloads.haskell.org/ghc/8.10.7/ghc-8.10.7-x86_64-deb9-linux.tar.xz \
  && tar -xf ghc-8.10.7-x86_64-deb9-linux.tar.xz \
  && rm ghc-8.10.7-x86_64-deb9-linux.tar.xz \
  && cd ghc-8.10.7 \
  && ./configure \
  && make install

# Build and install cardano node
WORKDIR /opt
ARG TAG=1.34.1
RUN git clone https://github.com/input-output-hk/cardano-node.git \
  && cd cardano-node \
  && git fetch --all --recurse-submodules --tags \
  && git tag && git checkout tags/$TAG \
  && cabal configure --with-compiler=ghc-8.10.7 \
  && echo "package cardano-crypto-praos" >>  cabal.project.local \
  && echo "  flags: -external-libsodium-vrf" >>  cabal.project.local \
  && cabal build -j16 all \
  && mkdir /opt/bin/ \
  && cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.7/cardano-node-$TAG/x/cardano-node/build/cardano-node/cardano-node /opt/bin/ \
  && cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.7/cardano-cli-$TAG/x/cardano-cli/build/cardano-cli/cardano-cli /opt/bin/

# Build the final stage and copy the build artifacts from the previous stage.
FROM debian:buster-slim
COPY --from=build /usr/local/lib/libsodium.so* /usr/local/lib/
COPY --from=build /opt/bin/cardano-cli /usr/local/bin/
COPY --from=build /opt/bin/cardano-node /usr/local/bin/
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

# Install required packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      netbase \
    && rm -rf /var/lib/apt/lists/*

# Setup default user environment
ARG USERNAME="lovelace"
ARG USERID="1000"
ARG GROUPID="1024"
RUN groupadd -g $GROUPID -r $USERNAME \
  && useradd --no-log-init -r --gid $GROUPID -u $USERID $USERNAME \
  && mkdir /home/$USERNAME \
  && chown -R ${USERID}:${GROUPID} /home/${USERNAME} \
  && echo ${USERNAME}:${USERNAME} | chpasswd
USER ${USERNAME}

# Create a directory for the node config files and blockchain database. 
# This needs to be mounted to a host volume on container run.
RUN mkdir /home/${USERNAME}/cardano-node/

# Set cardano-node as the entrypoint and by default just print the version.
ENTRYPOINT ["cardano-node"]
CMD ["--version"]

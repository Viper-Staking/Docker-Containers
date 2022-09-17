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
  liblmdb-dev \
  curl

# Setup the Haskell Environement
WORKDIR /opt
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ENV PATH="$PATH:/root/.ghcup/bin/"
RUN ghcup install ghc 8.10.7 \
 && ghcup install cabal 3.6.2.0 \
 && ghcup set ghc 8.10.7 \
 && ghcup set cabal 3.6.2.0

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

# Download and install libsecp256k1:
WORKDIR /opt
RUN git clone https://github.com/bitcoin-core/secp256k1 \
 && cd secp256k1 \
 && git checkout ac83be33 \
 && ./autogen.sh \
 && ./configure --enable-module-schnorrsig --enable-experimental \
 && make -j16 \
 && make install

# Build and install cardano node
WORKDIR /opt
ARG TAG=1.35.3
RUN git clone https://github.com/input-output-hk/cardano-node.git \
 && cd cardano-node \
 && git fetch --all --recurse-submodules --tags \
 && git tag && git checkout tags/$TAG \
 && echo "with-compiler: ghc-8.10.7" >>  cabal.project.local \
 && cabal build -j16 all \
 && mkdir /opt/bin/ \
 && cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.7/cardano-node-$TAG/x/cardano-node/build/cardano-node/cardano-node /opt/bin/ \
 && cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.7/cardano-cli-$TAG/x/cardano-cli/build/cardano-cli/cardano-cli /opt/bin/

# Build the final stage and copy the build artifacts from the previous stage.
FROM debian:buster-slim
COPY --from=build /usr/local/lib/libsodium.so* /usr/local/lib/
COPY --from=build /usr/local/lib/libsecp256k1* /usr/local/lib/
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

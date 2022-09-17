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

# Install Rust
WORKDIR /opt
RUN mkdir -p $HOME/.cargo/bin \
 && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install stable && rustup default stable && rustup update \
 && rustup component add clippy rustfmt

# Build and install CNCLI
WORKDIR /opt
ARG CNCLI_TAG=v5.1.2
RUN git clone --recurse-submodules https://github.com/cardano-community/cncli.git \
 && cd cncli \
 && git checkout $CNCLI_TAG \
 && cargo install --path . --force \
 && cncli --version

# Install Prometheus Node Exporter
ARG VERSION=1.0.1
ARG DIRNAME="node_exporter-$VERSION.linux-amd64"
WORKDIR /opt
RUN wget https://github.com/prometheus/node_exporter/releases/download/v$VERSION/$DIRNAME.tar.gz \
 && tar xvfz $DIRNAME.tar.gz \
 && mv $DIRNAME/node_exporter /usr/local/bin

# Build the final stage and copy the build artifacts from the previous stage.
FROM registry.gitlab.com/viper-staking/docker-containers/debian-base:latest
COPY --from=build /usr/local/lib/libsodium* /usr/local/lib/
COPY --from=build /usr/local/lib/libsecp256k1* /usr/local/lib/
COPY --from=build /opt/bin/cardano-cli /usr/local/bin/
COPY --from=build /opt/bin/cardano-node /usr/local/bin/
COPY --from=build /usr/local/bin/node_exporter /usr/local/bin
COPY --from=build /root/.cargo/bin/cncli /usr/local/bin
COPY --from=build /opt/cncli/scripts/ /root/scripts
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Copy over other resources from the build context.
COPY entrypoint.sh /usr/local/bin/

# Create a directory for the node config files and blockchain database. 
# This needs to be mounted to a host volume on container run.
RUN mkdir ${HOME}/cardano-node/

# Clone the cardano-tools repo
RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install cardano-tools

# Expose prometheus monitoring ports
EXPOSE 9100
EXPOSE 12798

# Set cardano-node as the entrypoint and by default just print the version.
ENTRYPOINT ["entrypoint.sh"]
CMD ["--version"]

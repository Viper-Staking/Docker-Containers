FROM registry.gitlab.com/viper-staking/docker-containers/debian-base:latest
MAINTAINER VIPER Staking Team (viperstakepool@gmail.com)

USER root

# Update and install the required packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  curl \
  tmux \
  git \
  jq \
  wget

WORKDIR /opt

# Install Jormungandr
RUN curl -sSLO https://github.com/input-output-hk/jormungandr/releases/download/v0.9.1/jormungandr-0.9.1-x86_64-unknown-linux-gnu-broadwell.tar.gz \
  && tar --extract --file jormungandr-0.9.1-x86_64-unknown-linux-gnu-broadwell.tar.gz \
  && rm jormungandr-0.9.1-x86_64-unknown-linux-gnu-broadwell.tar.gz \
  && mv jormungandr /usr/local/bin/ \
  && mv jcli /usr/local/bin

# Create node directories and download config files
#RUN mkdir node && cd node \
#  && wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/shelley_testnet-config.json \
#  && wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/shelley_testnet-genesis.json \
#  && wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/shelley_testnet-topology.json \
#  && mkdir db && touch db/node.socket

ARG USER=lovelace
RUN chown -R $USER:$USER /opt
USER $USER

CMD ["tmux"]

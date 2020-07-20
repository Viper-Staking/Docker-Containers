FROM rust:1.45-slim-buster AS build
LABEL maintainer="VIPER Staking Team (viperstakepool@gmail.com)"

# Install any needed packages
RUN apt-get update && apt-get install -y --no-install-recommends \
 git 

WORKDIR /opt/

# The latest stable version is recommended.
RUN rustup install stable \
  && rustup default stable \
  && rustup component add rustfmt

# Build the Jormungandr executable.
ARG TAG=v0.9.1
RUN git clone --recurse-submodules https://github.com/input-output-hk/jormungandr \
  && cd jormungandr \
  && git checkout tags/$TAG \
  && git submodule update \
  && cargo install --locked --path jormungandr \
  && cargo install --locked --path jcli

# Create the final container and copy in the executables.
FROM debian:buster-slim
COPY --from=build /usr/local/cargo/bin/jormungandr /usr/local/bin/
COPY --from=build /usr/local/cargo/bin/jcli /usr/local/bin/

# Setup the user and group for sharing folders with the host.
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
# This can be mounted to a host volume when the container is run.
RUN mkdir $HOME/jormungandr-node/

# Copy or clone any tools needed here.


# Set jormungandr as the entrypoint and by default just print the version.
ENTRYPOINT ["jormungandr"]
CMD ["--version"]

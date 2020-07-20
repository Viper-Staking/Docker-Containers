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
FROM registry.gitlab.com/viper-staking/docker-containers/debian-base:latest
COPY --from=build /usr/local/cargo/bin/jormungandr /usr/local/bin/
COPY --from=build /usr/local/cargo/bin/jcli /usr/local/bin/

# Copy or clone any tools needed here.


# Set jormungandr as the entrypoint and by default just print the version.
ENTRYPOINT ["jormungandr"]
CMD ["--version"]

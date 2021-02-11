# cardano-node container

This project builds the cardano-node software from source inside a debian based docker container for rapid deployment to multiple nodes. The container also installs the Prometheus node exporter to support remote monotiring using [Prometheus](https://prometheus.io/).

See the Dockerfile and build.sh script for more information.

## Default configuration (cardano-node binary)
This container runs with the `cardano-node` as the `ENTRYPOINT` (see inside the `entrypoint.sh` script). A `CMD` statement provides a default argument if no arguments are provided when running the container. This will simply print the cardano-node version.

Note: Make sure to `export HOME=/home/lovelace` so that it can be resolved correctly within the container

The following command will run the container in this configuration:
``` bash
docker run registry.gitlab.com/viper-staking/docker-containers/cardano-node:latest
```

## Alternate configuration (block producing node)
Below is an example on overriding the default CMD arguments to run cardano-node 
as a block producing node:
``` bash
docker run registry.gitlab.com/viper-staking/docker-containers/cardano-node:latest \
    run \
    --database-path $HOME/cardano-node/db/ \
    --socket-path $HOME/cardano-node/db/node.socket \
    --host-addr "0.0.0.0" \
    --port 4444 \
    --config $HOME/cardano-node/config.json \
    --topology $HOME/cardano-node/topology.json \
    --shelley-kes-key $HOME/cardano-node/pool_kes.skey \
    --shelley-vrf-key $HOME/cardano-node/pool_vrf.skey
```

## Alternate configuration (relay node)
Below is an example on overriding the default CMD arguments to run cardano-node 
as a relay node:
``` bash
docker run registry.gitlab.com/viper-staking/docker-containers/cardano-node:latest \
    run \
    --database-path $HOME/cardano-node/db/ \
    --socket-path $HOME/cardano-node/db/node.socket \
    --port 4444 \
    --host-addr "0.0.0.0" \
    --topology $HOME/cardano-node/topology.json \
    --config $HOME/cardano-node/config.json
```

## Alternate configuration (shell entrypoint)
Below is an example on overriding the entrypoint to enter the container in a 
shell. This configuration boots the container into a ZSH shell so that the user
can interact with the container and run any desired commands. Use this for
debugging:
``` bash
docker run -it --entrypoint /usr/bin/zsh registry.gitlab.com/viper-staking/docker-containers/cardano-node:latest
```

## The `slim` build

A `slim` version of the container is also provided that has no extra tools 
installed for minimal container size. This may be useful when merely using the 
container as a `cardano-node` executable.

## Quickstart

Follow our [quickstart guide](https://viperstaking.com/ada-tools/node-quickstart/) 
to get a relay node up and running using this container in less than 10 minutes!

---

_Visit our [website](https://viperstaking.com) for information on our other open source Cardano tools. If you find our tools useful, please consider buying us a beer! :beer: [Contribute](https://viperstaking.com/ada-tools/contribute/)_

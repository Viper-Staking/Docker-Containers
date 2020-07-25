# cardano-node container

## Default configuration (cardano-node binary)
This container runs with `ENTRYPOINT cardano-node`. A `CMD` statement provides a
default argument if no arguments are provided when running the container. This 
will simply print the cardano-node version.

The following command will run the container in this configuration:
``` bash
docker run registry.gitlab.com/viper-staking/docker-containers/cardano-node:latest
```

## Alternate configuration (block producing node)
Below is an example on overriding the default CMD arguments to run cardano-node 
as a block producing node:
``` bash
docker run registry.gitlab.com/viper-staking/docker-containers/cardano-node:latest \
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
    --database-path $HOME/cardano-node/db/ \
    --socket-path $HOME/cardano-node/db/node.socket \
    --port 4444 \
    --host-addr "0.0.0.0" \
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

## Running with run-cardano-node script
The script `run-cardano-node.sh` is provided to simplify running the 
cardano-node either via the docker container or from a local installation. The 
first argument accepts a command prefix string which specifies where to execute cardano-node so it may be used with the container as:

### Docker execution
``` bash
export CMD="docker run --mount type=bind,source=$PWD,target=/home/lovelace/cardano-node/ -p 9100:9100 -p 12798:12798 registry.gitlab.com/viper-staking/docker-containers/cardano-node:latest"
./run-cardano-node.sh $CMD
```

The `run-cardano-node.sh` script assumes the location of the node configuration 
files and may need to be adjuster per your setup.

You can open a shell in the running container with the following command:
``` bash
docker exec -it <container_id> /usr/bin/zsh
```

You can get the ID of the running container by running `docker ps`.

### Local execution
Use this to run cardano-node from a local cardano installation (or to run 
cardano-node when inside the docker container via shell):
``` bash
export CMD="/usr/local/bin/cardano-node"
./run-cardano-node.sh $CMD
```

## Required files
* Node configuration files (latest files [here](https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html))
  * config.json
  * topology.json
  * genesis.json

These files are different depending on the network (e.g., testnet vs. mainnet)
and may be fetched automatically using the provided `get_latest_config_files.sh`
script.

## Monitor node with prometheus

0. Ensure the node has been updated to enable prometheus by adding the following
to the `config.json` file:

```
hasPrometheus:
   - "0.0.0.0"
   - 12789
```

1. Pull prometheus docker container from [Dockerhub](https://hub.docker.com/r/prom/prometheus):
``` bash
docker pull prom/prometheus
```

2. Get the IP address of the node you'd like to monitor. If using docker, you can get the IP with:
``` bash
docker network inspect bridge
```
3. Modify prometheus.yml and change `localhost` to the container's IP address
4. Run the prometheus container:
``` bash
docker run \
    -p 9090:9090 \
    -v $PWD/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus
```
5. Access the prometheus web UI at `<container IP>:9090/graph`

## The `slim` tag

A `slim` version of the container is also provided that has no extra tools 
installed for minimal container size. This may be useful when merely using the 
container as a `cardano-node` executable.

---
Visit our [website](https://viperstaking.com) for information on our other open source Cardano tools. If you find our tools useful, please consider buying us a beer! :beer:

**ADA Wallet:** `DdzFFzCqrhstZCw5CwyKLaDvna3Myfioi1LL4up4D5nn5q4QyyhEw5nLNs5g46sTaCarHJKtLwviL1s5Ed6mdRUhX2vBc6A8queoJMpF`

**BTC Wallet:** `39sUg4DKBNHAFq5TeUJ8aiFGe7QpptifHE`

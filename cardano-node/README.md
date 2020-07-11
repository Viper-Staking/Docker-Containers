# cardano-node container

## Default configuration (relay node)
This container runs with `ENTRYPOINT cardano-node`. A `CMD` statement provides default arguments,
which runs a relay node with the following parameters:

* Base path (for database and config paths): '$HOME/cardano-node'
* Port: `4444`
* Host address: `0.0.0.0`

The following command will run the container in this configuration:
``` bash
docker run cardano-node
```

## Alternate configuration (block producing node)
Below is an example on overriding the default CMD arguments to run cardano-node as a block
producing node:
``` bash
docker run cardano-node \
    --database-path $HOME/cardano-node/db/ \
    --socket-path $HOME/cardano-node/db/node.socket \
    --host-addr "0.0.0.0" \
    --port 4444 \
    --config $HOME/cardano-node/config.json \
    --topology $HOME/cardano-node/topology.json \
    --shelley-kes-key $HOME/cardano-node/pool_kes.skey \
    --shelley-vrf-key $HOME/cardano-node/pool_vrf.skey \
```

## Alternate configuration (relay node)
Below is an example on overriding the default CMD arguments to run cardano-node as a relay
node:
``` bash
docker run cardano-node \
    --database-path $HOME/cardano-node/db/ \
    --socket-path $HOME/cardano-node/db/node.socket \
    --port 4444 \
    --host-addr "0.0.0.0" \
    --config $HOME/cardano-node/config.json \

## Alternate configuration (shell entrypoint)
Below is an example on overriding the entrypoint to enter the container in a shell:
``` bash
docker run -it --entrypoint /usr/bin/zsh cardano-node
```

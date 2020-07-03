#!/bin/bash

if [ -z $1 ]; then
  CNODE_MODE="relay"
else
  CNODE_MODE=$1
fi

if [ -z $2 ]; then
  CNODE_PORT=4444
else
  CNODE_PORT=$2
fi

if [ -z $3 ]; then
  HOST_ADDR="0.0.0.0"
else
  HOST_ADDR=$3
fi

if [ "$CNODE_MODE" = "relay" ]; then
  cardano-node run \
    --database-path $HOME/cardano-node/db/ \
    --socket-path $HOME/cardano-node/db/node.socket \
    --port $CNODE_PORT \
    --host-addr $HOST_ADDR \
    --config $HOME/cardano-node/config.json \
    --topology $HOME/cardano-node/topology.json
elif [ "$CNODE_MODE" = "pool" ]; then
  cardano-node run \
    --database-path $HOME/cardano-node/db/ \
    --socket-path $HOME/cardano-node/db/node.socket \
    --host-addr $HOST_ADDR \
    --port $CNODE_PORT \
    --config $HOME/cardano-node/config.json \
    --topology $HOME/cardano-node/topology.json \
    --shelley-kes-key $HOME/cardano-node/kes.skey \
    --shelley-vrf-key $HOME/cardano-node/vrf.skey \
    --shelley-operational-certificate  $HOME/cardano-node/node.cert
fi

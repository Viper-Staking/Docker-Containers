#!/bin/bash
# run-cardano-node
# Arguments:
#   1 - command prefix: Path to cardano-node executable or 'docker run' command [default: cardano-node]
#   2 - base path: Path containing cardano-node directory
#   3 - node mode: Node operation mode, "relay" or "pool" [default: relay]
#   4 - node port [default: 4444]
#   5 - host address [default: 0.0.0.0]

if [ $# -ge 1 ]; then
  CMD_PREFIX="$1"
else
  CMD_PREFIX="cardano-node"
fi

if [ $# -ge 2 ]; then
  BASE_PATH=$2
else
  BASE_PATH=/home/lovelace
fi

if [ $# -ge 3 ]; then
  CNODE_MODE=$3
else
  CNODE_MODE="relay"
fi

if [ $# -ge 4 ]; then
  CNODE_PORT=$4
else
  CNODE_PORT=4444
fi

if [ $# -ge 5 ]; then
  HOST_ADDR=$5
else
  HOST_ADDR="0.0.0.0"
fi

echo "Running cardano-node with the following parameters:"
echo "  CMD_PREFIX = $CMD_PREFIX"
echo "  BASE_PATH  = $BASE_PATH"
echo "  CNODE_MODE = $CNODE_MODE"
echo "  CNODE_PORT = $CNODE_PORT"
echo "  HOST_ADDR  = $HOST_ADDR"

if [ "$CNODE_MODE" = "relay" ]; then
  eval $CMD_PREFIX run \
    --database-path $BASE_PATH/cardano-node/db/ \
    --socket-path $BASE_PATH/cardano-node/db/node.socket \
    --port $CNODE_PORT \
    --host-addr $HOST_ADDR \
    --config $BASE_PATH/cardano-node/config.json \
    --topology $BASE_PATH/cardano-node/topology.json
elif [ "$CNODE_MODE" = "pool" ]; then
  eval $CMD_PREFIX run \
    --database-path $BASE_PATH/cardano-node/db/ \
    --socket-path $BASE_PATH/cardano-node/db/node.socket \
    --host-addr $HOST_ADDR \
    --port $CNODE_PORT \
    --config $BASE_PATH/cardano-node/config.json \
    --topology $BASE_PATH/cardano-node/topology.json \
    --shelley-kes-key $BASE_PATH/cardano-node/pool_kes.skey \
    --shelley-vrf-key $BASE_PATH/cardano-node/pool_vrf.skey \
    --shelley-operational-certificate $BASE_PATH/cardano-node/pool.cert
fi

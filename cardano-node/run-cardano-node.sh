if [[ -z "${CNODE_MODE}" ]]; then
  CARDANO_NODE_MODE="relay"
else
  CARDANO_NODE_MODE="${CNODE_MODE}"
fi

if [[ -z "${CNODE_PORT}" ]]; then
  CNODE_PORT=4444
fi

HOST_ADDR="0.0.0.0"

if [ "$CARDANO_NODE_MODE" == "relay" ]; then
   cardano-node run \
       --database-path $HOME/cardano-node/db/ \
       --socket-path $HOME/cardano-node/db/node.socket \
       --port $CNODE_PORT \
       --host-addr $HOST_ADDR \
       --config $HOME/cardano-node/config.json \
       --topology $HOME/cardano-node/topology.json
elif [ "$CARDANO_NODE_MODE" == "pool" ]; then
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

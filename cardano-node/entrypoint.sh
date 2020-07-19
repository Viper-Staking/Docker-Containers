#!/bin/bash
set -e

# Start prometheus monitoring in the background
echo "Starting node_exporter..."
nohup node_exporter --web.listen-address=":9100" &

# Start cardano-node, passing all CMD args to it
echo "Starting cardano-node with arguments:"
echo "$@"
exec cardano-node $@

BASELINK="https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/"

# Shelley Testnet
curl -sSL0 ${BASELINK}shelley_testnet-config.json config/shelley_testnet-config.json
curl -sSL0 ${BASELINK}shelley_testnet-shelley-genesis.json config/shelley_testnet-shelley-genesis.json
curl -sSL0 ${BASELINK}shelley_testnet-topology.json config/shelley_testnet-topology.json

# Mainnet Candidate
curl -sSL0 ${BASELINK}mainnet_candidate-config.json config/mainnet_candidate-config.json
curl -sSL0 ${BASELINK}mainnet_candidate-shelley-genesis.json config/mainnet_candidate-shelley-genesis.json
curl -sSL0 ${BASELINK}mainnet_candidate-byron-genesis.json config/mainnet_candidate-byron-genesis.json
curl -sSL0 ${BASELINK}mainnet_candidate-topology.json config/mainnet_candidate-topology.json

# # Mainnet
# curl -sSL0 ${BASELINK}mainnet-config.json config/mainnet-config.json
# curl -sSL0 ${BASELINK}mainnet-shelley-genesis.json config/mainnet-shelley-genesis.json
# curl -sSL0 ${BASELINK}mainnet-byron-genesis.json config/mainnet-byron-genesis.json
# curl -sSL0 ${BASELINK}mainnet-topology.json config/mainnet-topology.json

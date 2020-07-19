LATEST="https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html"

# Shelley Testnet
curl -sSLO ${BASELINK}shelley_testnet-config.json
curl -sSLO ${BASELINK}shelley_testnet-shelley-genesis.json
curl -sSLO ${BASELINK}shelley_testnet-topology.json

# Mainnet Candidate
curl -sSLO ${BASELINK}mainnet_candidate-config.json
curl -sSLO ${BASELINK}mainnet_candidate-shelley-genesis.json
curl -sSLO ${BASELINK}mainnet_candidate-byron-genesis.json
curl -sSLO ${BASELINK}mainnet_candidate-topology.json

# # Mainnet
# curl -sSLO ${BASELINK}mainnet-config.json
# curl -sSLO ${BASELINK}mainnet-shelley-genesis.json
# curl -sSLO ${BASELINK}mainnet-byron-genesis.json
# curl -sSLO ${BASELINK}mainnet-topology.json
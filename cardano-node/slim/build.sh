docker login registry.gitlab.com
docker build -t registry.gitlab.com/viper-staking/docker-containers/cardano-node:slim .
docker push registry.gitlab.com/viper-staking/docker-containers/cardano-node:slim

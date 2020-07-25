if [ -z "$1" ]; then
    TAG="latest"
else
    TAG=$1
fi
docker login registry.gitlab.com
docker build -t registry.gitlab.com/viper-staking/docker-containers/cardano-node:$TAG .
docker push registry.gitlab.com/viper-staking/docker-containers/cardano-node:$TAG

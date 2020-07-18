docker login registry.gitlab.com
docker build -t registry.gitlab.com/viper-staking/docker-containers/jormungandr:latest .
docker push registry.gitlab.com/viper-staking/docker-containers/jormungandr:latest

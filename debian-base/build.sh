docker login registry.gitlab.com
docker build -t registry.gitlab.com/viper-staking/docker-containers/debian-base:latest .
docker push registry.gitlab.com/viper-staking/docker-containers/debian-base:latest

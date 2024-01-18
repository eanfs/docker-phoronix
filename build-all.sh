#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}


artifactId=xde-phoronix-test-suite
version=10.8.4

# hub.docker.com/szopen
group=swr.cn-east-3.myhuaweicloud.com/intetech

# docker
# docker buildx build --platform linux/amd64,linux/arm64 -t ${artifactId}:${version} --push -f ./Dockerfile .
# docker buildx build --no-cache --platform=linux/amd64 -t ${artifactId}:${version}-amd64 --build-arg PHORONIX_VERSION=${version} -o type=docker,dest=- . > ${artifactId}-amd64.tar
docker buildx build --no-cache --platform=linux/arm64 -t ${artifactId}:${version}-arm64 --build-arg PHORONIX_VERSION=${version} -o type=docker,dest=- . > ${artifactId}-arm64.tar
# #docker tag  ${artifactId}:${version}  ${artifactId}:latest

docker load < ${artifactId}-amd64.tar
docker load < ${artifactId}-arm64.tar

# docker buildx imagetools inspect lrc32/xde-temurin:11-jdk-focal-cn

docker tag ${artifactId}:${version}-amd64 ${group}/${artifactId}:${version}-amd64
docker push ${group}/${artifactId}:${version}-amd64

docker tag ${artifactId}:${version}-arm64 ${group}/${artifactId}:${version}-arm64
docker push ${group}/${artifactId}:${version}-arm64


# push version manifest
docker manifest rm ${group}/${artifactId}:${version}
docker manifest create ${group}/${artifactId}:${version} \
--amend ${group}/${artifactId}:${version}-amd64 \
--amend ${group}/${artifactId}:${version}-arm64

docker manifest push ${group}/${artifactId}:${version}

docker manifest rm ${group}/${artifactId}:latest
# push latest manifest
docker manifest create ${group}/${artifactId}:latest \
--amend  ${group}/${artifactId}:${version}-amd64 \
--amend  ${group}/${artifactId}:${version}-arm64
docker manifest push ${group}/${artifactId}:latest


rm -rf ${artifactId}-amd64.tar
rm -rf ${artifactId}-arm64.tar
#####################
# Bench Dockerfile #
#####################

# Set the base image
FROM php:7.4.33-bullseye

WORKDIR /build
# File Author / Maintainer
LABEL maintainer="lirichen32@gmail.com"

ARG PHORONIX_VERSION

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apt/repositories
RUN  sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list


# Install dependencies
RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -yq install apt-utils && \
    apt-get -yq install apt-file autoconf unzip
# RUN apt-get install apt-utils
# RUN apt-get install php-dom php-zip 
# RUN apt-get install php-json php-simplexml

# Download  & extract Phoronix package
# RUN wget https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v${PHORONIX_VERSION}.tar.gz -O phoronix-test-suite.tar.gz
ADD phoronix-test-suite-${PHORONIX_VERSION}.tar.gz .
# RUN tar xzf phoronix-test-suite.tar.gz
# RUN rm -f phoronix-test-suite.tar.gz
RUN cd phoronix-test-suite-${PHORONIX_VERSION} && ./install-sh

# Install predefined tests
# RUN mkdir /var/lib/phoronix-test-suite/download-cache/
# COPY sysbench-1.0.20.tar.gz /var/lib/phoronix-test-suite/download-cache/
# COPY wrk-4.2.0.tar.gz /var/lib/phoronix-test-suite/download-cache/

## System
# RUN phoronix-test-suite install pts/sysbench
## Disk
RUN phoronix-test-suite install pts/fio
## CPU
RUN phoronix-test-suite install pts/cpuminer-opt
## Memory
RUN phoronix-test-suite install pts/stream
## Services
# RUN phoronix-test-suite install pts/apache
RUN phoronix-test-suite install pts/stress-ng
# RUN phoronix-test-suite install pts/gputest

# Copy custom scripts
COPY scripts/ .

# Begin benchmark script
CMD ./run.sh

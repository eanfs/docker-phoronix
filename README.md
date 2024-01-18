# docker-phoronix
Benchmarking docker container with phoronix test suite

This project deploys a docker container with Phoronix Test Suite installed, as well as a couple of tests that are predefined in the Dockerfile.  

The purpose of this container will solely be to benchmark your docker-machine.  
For ease of use, a couple of 'make commands' are supplied within this repo.

## Installation


After cloning the repository, just execute these commands:

#### Building the docker-phoronix image  

```
$ ./build-all.sh
```

#### Usage

```
$ ./run.sh
or 
docker run -it --rm swr.cn-east-3.myhuaweicloud.com/intetech/xde-phoronix-test-suite:latest
```

This will run the container together with the supplied script. The script returns a menu from which you can choose an option.

![alt text](img/docker-phoronix.png "Menu")

After you exit from this menu, the docker-phoronix container will be automatically removed.

NOTE: Don't use CTRL+C to exit the make command. This could result in the script being stuck in a loop and you will have to kill and remove the container manually.


docker build --no-cache --progress=plain -t xde-phoronix-test-suite:10.8.4 --build-arg PHORONIX_VERSION=10.8.4 .
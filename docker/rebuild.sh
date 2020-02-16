#!/bin/bash

source vars

docker stop geodb-equinox
docker rm geodb-equinox
docker rmi equinox:4.13
docker rmi geodb-equinox:4.13

docker build -t equinox:4.13 -f equinox.Dockerfile .
docker build \
--build-arg p2_user=$p2_user \
--build-arg p2_pass=$p2_pass \
--build-arg p2_host=$p2_host \
-t geodb-equinox:4.13 \
-f geodb-equinox.Dockerfile .

docker run -p5000:5000 -p5001:5001 -d --name geodb-equinox geodb-equinox:4.13

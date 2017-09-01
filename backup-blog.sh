#!/bin/bash

docker commit $(docker ps | grep blog | awk '{print $1}') 297951292/blog
docker push 297951292/blog
docker rmi -f $(docker images | grep none | awk '{print $3}')

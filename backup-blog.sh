#!/bin/bash

nowWithSecond=$(date +%Y\-%m\-%d\ %H\:%M\:%S)

echo $nowWithSecond

docker commit $(docker ps | grep blog | awk '{print $1}') 297951292/blog
docker push 297951292/blog > /dev/null
docker system prune -f

echo 'done'

#!/bin/bash

nowWithSecond=$(date +%Y\-%m\-%d\ %H\:%M\:%S)
tag=$(date -I)

echo $nowWithSecond

docker commit $(docker ps | grep blog | awk '{print $1}') 297951292/blog:$tag
docker push 297951292/blog:$tag > /dev/null

docker tag 297951292/blog:$tag 297951292/blog:latest
docker push 297951292/blog:latest > /dev/null

docker system prune -f

images=$(docker images | awk 'NR>3{print $3}' | sed '$d' | sed '$d')
if [ $images ]; then docker rmi $images; fi

echo 'done'

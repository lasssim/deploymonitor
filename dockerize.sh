#!/bin/bash

if [ -d "./stairlightsrb" ]; then
  cd stairlightsrb
  git pull
  cd ..
else
  git clone https://github.com/lister/stairlightsrb.git
fi

cd stairlightsrb

VERSION=0.1
REPOSITORY=lister/stairlights-deploy
NAME=$REPOSITORY:$VERSION

docker build . -t $NAME
#docker run $NAME
#docker push $NAME
docker run -i -t --privileged --cap-add SYS_RAWIO --device /dev/mem lister/stairlights-deploy:0.1



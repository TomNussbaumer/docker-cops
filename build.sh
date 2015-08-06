#!/bin/bash

[ -d tmp ] && rm -rf tmp
mkdir -p tmp/home && cd tmp/home
git clone https://github.com/seblucas/cops.git
cd cops
sed "s|'./'|'./library/'|" < config_local.php.example > config_local.php
cd ../..
mv home/cops/test/BaseWithSomeBooks test-library
rm -rf home/cops/test
tar -cvf cops.tar home
cd ..
docker build -t docker-cops:fat-one .
rm tmp/cops.tar

# Flatten the image stack by exporting the filesystem from a temporary
# container and importing it back as a new image.
# This way we get rid of a deleted files.
container=$(docker create docker-cops:fat-one)
./tools/docker-rebase.sh $container docker-cops:latest
docker rm $container

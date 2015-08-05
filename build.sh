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
docker build -t docker-cops:latest .
rm tmp/cops.tar

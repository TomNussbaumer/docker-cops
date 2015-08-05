#!/bin/bash

[ -d tmp ] && rm -rf tmp
mkdir tmp
cd tmp
mkdir home
cd home
git clone https://github.com/seblucas/cops.git
cd cops
sed "s|'./'|'./library/'|" < config_local.php.example > config_local.php
cd ../..
tar -cvf cops.tar home
cd ..
docker build -t docker-cops:latest .

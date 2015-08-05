#!/bin/bash

function canonical_path() {
  # Handle relative vs absolute path
  [ ${1:0:1} == '/' ] && x=$1 || x=$PWD/$1
  # Change to dirname of x
  cd ${x%/*}
  # Combine new pwd with basename of x
  echo $(pwd -P)/${x##*/}
  cd $OLDPWD
}

if [ -z "$1" -o -z "$2" ]; then
  echo "USAGE: $0 ABSPATH-TO-LIBRARY PORT-TO_USE [--daemon]" 1>&2
  echo ""
  echo "starts an instance of COPS serving the library on the given port."
  echo "If '--daemon' is given, the instance starts in daemon mode."
  echo ""
  echo "test library => $(dirname $(canonical_path "${BASH_SOURCE[0]}"))/tmp/test-library"
  echo ""
  exit 1
else
  echo "ABSPATH-TO-LIBRARY   = '$1'"
  echo "PORT-TO-USE          = '$2'"
fi

if [ "$3" == "--daemon" ]; then
  echo "starting as daemon   =  http://localhost:$2"
  echo ""
  docker run -d -v "$1":/home/cops/library -p "$2":8080 docker-cops
else
  echo "starting interactive = http://localhost:$2"
  echo ""
  docker run -ti -v "$1":/home/cops/library -p "$2":8080 --rm docker-cops
fi
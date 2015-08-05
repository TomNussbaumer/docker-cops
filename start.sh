#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <abspath-library> <port-to-use>"
  exit 1
else
  echo "abspath-library = '$1'"
  echo "port-to-use     = '$2'"
fi

# to run it daemonized
#docker run -d -v "$1":/home/cops/library -p "$2":8080 --rm dockercops

# to run it in interactive mode
docker run -i -t -v "$1":/home/cops/library -p "$2":8080 --rm dockercops

#!/bin/bash

# script to start a dockerized version of cops.
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Tom Nussbaumer <thomas.nussbaumer@gmx.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

ABSPATH_SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
ABSPATH_DIR=$(dirname "$ABSPATH_SCRIPT")

if [ -z "$1" -o -z "$2" ]; then
  TESTLIB="$ABSPATH_DIR"/tmp/test-library
  TESTLIB=${TESTLIB// /\\ }
  echo "USAGE: $0 PATH-TO-LIBRARY PORT-TO_USE [USER] [PASSWD] [--daemon]" 1>&2
  echo ""
  echo "starts an instance of COPS serving the library on the given port."
  echo "If '--daemon' is given, the instance starts in daemon mode."
  echo "For simple security (basic authentication) set USER and PASSWD."
  echo ""
  echo "test library => $TESTLIB"
  echo ""
  exit 1
fi

CALIBRE_LIB=$(readlink -f "$1")
echo "PATH-TO-LIBRARY      = '$1'"
echo "ABSPATH-TO-LIBRARY   = '$CALIBRE_LIB'"
echo "PORT-TO-USE          = '$2'"

[ "$3" = "--daemon" -o "$5" = "--daemon" ]
DAEMON_MODE=$?

CALIBRE_LIB=${CALIBRE_LIB// /\\ }
CMDLINE="docker run -v $CALIBRE_LIB:/home/cops/library -p $2:8080"

#------------------------------------------------------------------------------
# check if we should run with basic authenication enabled
#
# NOTE: the tricky part here is to get it right when username or password
#       contains spaces. Simply using quotes won't work as expected.
#------------------------------------------------------------------------------
if [ -n "$3" -a -n "$4" ]; then
  ESC_USER=${3// /\\ }
  ESC_PWD=${4// /\\ }
  CMDLINE="$CMDLINE -e BASICAUTH_USERNAME=$ESC_USER -e BASICAUTH_PASSWORD=$ESC_PWD"
  echo "[$CMDLINE]"
else
  echo "[$CMDLINE]"
fi

if [ $DAEMON_MODE -eq 0 ]; then
  echo "starting as daemon   =  http://localhost:$2"
  echo ""
  CMDLINE="$CMDLINE -d docker-cops"
else
  echo "starting interactive = http://localhost:$2"
  echo ""
  CMDLINE="$CMDLINE -ti --rm docker-cops"
fi

eval $CMDLINE

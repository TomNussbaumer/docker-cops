#!/bin/bash

# script to start a dockerized version of cops.
#
# Copyright (C) 2015 thomas.nussbaumer@gmx.net

#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>

ABSPATH_SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
ABSPATH_DIR=$(dirname "$ABSPATH_SCRIPT")

if [ -z "$1" -o -z "$2" ]; then
  TESTLIB="$ABSPATH_DIR"/tmp/test-library
  TESTLIB=${TESTLIB// /\\ }
  echo "USAGE: $0 PATH-TO-LIBRARY PORT-TO_USE [USER] [PASSWD] [--daemon]" 1>&2
  echo ""
  echo "starts an instance of COPS serving the library on the given port."
  echo "If '--daemon' is given, the instance starts in daemon mode."
  echo "For simple security (basic authenication) set USER and PASSWD."
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
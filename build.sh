#!/bin/bash

# script to build a dockerized version of cops.
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

[ -d tmp ] && rm -rf tmp
mkdir -p tmp/home && cd tmp/home

#------------------------------------------------------------------------------
# clone cops and checkout tested tag
#
# NOTE: it's up to you which version you want. I have test with 1.0.0RC3.
#------------------------------------------------------------------------------
git clone https://github.com/seblucas/cops.git
git checkout tags/1.0.0RC3
cd cops

#------------------------------------------------------------------------------
# set a dummy library path. start.sh will mount the library there.
#------------------------------------------------------------------------------
sed "s|'./'|'./library/'|" < config_local.php.example > config_local.php

#------------------------------------------------------------------------------
# to enable basic authenication we will use environment variables set by
# start.sh. Add a php block to handle this.
#------------------------------------------------------------------------------
cat <<E-O-T >> config_local.php

    /*
     * Enable simple basic authentication if required environment variables are set
     */
    if ((\$basicauth_username = getenv('BASICAUTH_USERNAME')) &&
        (\$basicauth_password = getenv('BASICAUTH_PASSWORD')))
    {
       //error_log("user=\$basicauth_username");
       //error_log("pass=\$basicauth_password");

       \$config['cops_basic_authentication'] = array( "username" => \$basicauth_username, "password" => \$basicauth_password );
    }
    else  {
       \$config['cops_basic_authentication'] = NULL;
    }
E-O-T

#------------------------------------------------------------------------------
# move test library to tmp directory, remove the rest of test folder and
# generate tar file with cops content
#------------------------------------------------------------------------------
cd ../..
mv home/cops/test/BaseWithSomeBooks test-library
rm -rf home/cops/test
tar -cvf cops.tar home
cd ..

#------------------------------------------------------------------------------
# build the "fat" version of the image and cleanup some stuff
#------------------------------------------------------------------------------
docker build -t docker-cops:fat-one .
rm tmp/cops.tar
rm -rf tmp/home

#------------------------------------------------------------------------------
# Flatten the image stack by exporting the filesystem from a temporary
# container and importing it back as a new image. This way we get rid of a
# deleted files which would otherwise still take up space.
# final size shrinks from 480MB down to 224MB.
#------------------------------------------------------------------------------
container=$(docker create docker-cops:fat-one)
./tools/docker-rebase.sh $container docker-cops:latest
docker rm $container
docker rmi docker-cops:fat-one

#------------------------------------------------------------------------------
# show proudly what we have built ;)
#------------------------------------------------------------------------------
docker images docker-cops

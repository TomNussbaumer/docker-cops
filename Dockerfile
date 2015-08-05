###################################################################
# running COPS (calibre library server) embedded in a docker image 
#
# COPS: https://github.com/seblucas/cops
###################################################################
#
# NOTE: the official base image for PHP seems to be quite heavy
#       with its 440 MB, but it comes with the complete sources
#       and build environment installed.
#       This is VERY useful when you need to install some more
#       extensions like we have to do in our case.
#
# TODO: minimize it after everything is setup correctly
#       (this will require an export of the final filesystem
#        and the generation of new 'history-free' image)
#
###################################################################

FROM php:5.6.11
MAINTAINER Tom Nussbaumer <thomas.nussbaumer@gmx.net>

#------------------------------------------------------------------
# extension gd is missing install it and build php
#------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

#------------------------------------------------------------------
# add cops sources
#------------------------------------------------------------------
ADD tmp/cops.tar /

#------------------------------------------------------------------
# setup a none privileged user account to run the services
#------------------------------------------------------------------
RUN groupadd -r dummy && useradd -r -g dummy dummy
USER dummy
WORKDIR /home/cops

#------------------------------------------------------------------
# use php's builtin webserver to run the cops system
#------------------------------------------------------------------
CMD php -S 0.0.0.0:8080

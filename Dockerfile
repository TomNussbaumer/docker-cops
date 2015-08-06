###################################################################
# running COPS (calibre library server) embedded in a docker image 
#
# COPS: https://github.com/seblucas/cops
###################################################################
#
# NOTE 1: the official base image for PHP seems to be quite heavy
#         with its 440 MB, but it comes with the complete sources
#         and build environment installed.
#         This is VERY useful when you need to install some more
#         extensions like we have to do in our case.
#
# NOTE 2: to minimize the final image, the sources and build tools
#         gets removed.
#
# NOTE 3: collapsing the image stack is required as postprocess.
#         otherwise the removed files will still waste space.
#         see build.sh for details.
#
###################################################################

FROM php:5.6.11
MAINTAINER Tom Nussbaumer <thomas.nussbaumer@gmx.net>

#------------------------------------------------------------------
# extension gd is missing.
# install it, build php and do some very quick and very very dirty 
# cleanup (i.e. removing complete sources, docs)
#------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && apt-get remove -y gcc \
    && apt-get autoremove -y \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/src/* /usr/share/doc/*

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
EXPOSE 8080
CMD php -S 0.0.0.0:8080

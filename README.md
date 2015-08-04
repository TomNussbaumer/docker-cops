# docker-cops

If you want to run a lightweight web interface for a calibre library you can use [cops](https://github.com/seblucas/cops.git). This project focus on building and running cops in a docker container.

**Prerequisites**

* git
* docker (>=1.7)

To build the docker image execute `./build.sh`. This will generate the image with name *dockercops*.

Suppose you have a calibre library located at /opt/library and want to serve it on port 5000:

`./start.sh /opt/library 5000`

**NOTE 1:** start.sh requires an absolute path to your library.

**NOTE 2:** Actually the produced image is quite large, because the used base image (php:5.6.11) contains the complete build environment of php including its source. With some cleanup and a final collapsing of the image stack it should be possible to get the size from 480MB down to ~200MB.



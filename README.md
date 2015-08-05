# docker-cops

If you want to run a lightweight web interface for a calibre library you can use [COPS](https://github.com/seblucas/cops.git). This project demonstrates how to building and run COPS in a docker container.

**Prerequisites**

* git
* docker (>=1.7)

To build the docker image execute `./build.sh`. This will generate an image with name *dockercops*.

Suppose you have a calibre library located at /opt/library and want to serve it on port 5000:

`./start.sh /opt/library 5000`

**NOTE 1:** start.sh requires an absolute path to your library.

**NOTE 2:** Actually the produced image is quite large, because the used base image (php:5.6.11) contains the complete build environment of php including its source. With some cleanup and a final collapsing of the image stack it should be possible to get the size from 480MB down to ~200MB.

**NOTE 3:** For the purpose of this demo start.sh starts the cops system in interactive mode. Press Ctrl+C to abort it (the container will be automatically removed).
 

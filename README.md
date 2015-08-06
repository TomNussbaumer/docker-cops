# docker-cops

## Summary

This demo shows how to embed a complete php site in a docker container and how to run it with the embedded PHP webserver.

## Motivation

I'm a great fan of ebook readers. You can read for days without running out of power and you can literally take an entire library consisting of thousands of books with you (without the burden of their weight).

When it comes down to ebooks and the administration of your own digital library, there is no way around [Calibre](http://calibre-ebook.com/). It's the most feature-rich (feature-complete?) opensource product in this sector actively developed and maintained since years.

I'm also a great fan of tiny, low cost and low power server environments. For private use it makes no sense to run power hungry hardware 24/7/365.25 (read: always on). Additionally I like the challenge. Everyone can develop software systems running on big servers (well, not literally everyone), but for getting stuff done on micro/nano systems, the software must be designed and optimized well.

Examples of low cost/low power environments I like are:

1. [Raspberry Pi](https://www.raspberrypi.org) and look-a-likes
2. The tiniest virtual server instances from commercial hosters (< $10 a month)
 
Running [Calibre](http://calibre-ebook.com/) in server mode on such a platform is possible. But due to fact that [Calibre](http://calibre-ebook.com/) is written in [Python](https://www.python.org/) it is memory hungry and slow and as your library grows and grows it becomes slower and slower (think of libraries containing >10k books).

Since ebook libraries tend to be static (with just some additions now and then), the best solution to get an ebook library online would be a static website generator. There is really no need for dynamic content in this case besides maybe search features. But even search can be added as static feature by utilizing some JSON index files and clientside searching.

For a static website generator to bring calibre libraries online see: [calibre2opds](http://calibre2opds.com)

For this demo I'm not using a static website generator, but a [PHP](https://de.wikipedia.org/wiki/PHP) powered system on the server side, which extracts the required data dynamically for each call from the calibre library's [sqlite](https://www.sqlite.org/) database. To keep things simple it will use the embbed PHP webserver which is sufficient for private use (get some books now and then).

## Details

[COPS](https://github.com/seblucas/cops.git) is a lightweight PHP system which brings a calibre library online. This project demonstrates how to build a docker image containing the complete environment including COPS itself and how to run it.

Note that **this demo is not a tutorial**. It just presents a working example which you can examine for the details.

*Prerequisites:*

1. *git*
2. *docker (>=1.7)*
3. *internet access for the build step*

To build the docker image execute `./build.sh`. This will generate an image with name *docker-cops*.

Suppose you have a calibre library located at /opt/library and want to serve it on port 5000:

`./start.sh /opt/library 5000`

## Notes:

1. Running `./start.sh` shows the usage info.
2. *start.sh* requires an absolute path to your library.
3. The base image is quite large, because it contains the complete build environment of php including its sources. The build process performs some really, really (sic!) dirty cleanup and image stack collapsing to get the final result size from 480MB down to 224MB.
4. For the purpose of this demo *start.sh* starts the container in interactive mode. Press Ctrl+C to abort it (the container will be automatically removed afterwards). To run it in daemon mode append *--daemon* to the commandline call.

## TODO:

1. Add configurable basic authentication to the demo so it can be used out-of-the-box to serve real content. 

## Additionally (not yet mentioned) resources used in this project

1. [Docker](https://www.docker.com/)
2. [PHP base image](https://registry.hub.docker.com/_/php/)
3. [docker script for image stack collapsing](https://github.com/docbill/docker-scripts)
 

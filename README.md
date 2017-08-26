# nodered-rpi
NodeRED on Raspbian (Raspberry Pi - ARMv7l platform)

To run this image and make it accessible on port 80 :
$ docker run -p 7777:80 -d <image name> 

By default, this image runs NodeRED under nodered account (UID 1234) and nodered group (GID 1234).
If on wants to access the GPIO, she must run the container as root and privileged, using the following docker parameters :
$ docker run -p 7777:80 -u root --privileged -d <image name>

If one wants to map a host directory inti the container, she can use the following syntax :
$ docker run -p 7777:80 -v /vol1:<host directory> -d <image name> 

This Docker file adds NodeRED on top of byte13/rpi-raspbian-nodejs:6.11.2.
The build possibly updates the base image and utilities.

Please, note that the "npm install" commands return errors.
NodeRED still works but the Dockerfile has to be improved to possibly remove the errors.
Suggestions welcome :-)

According to https://forums.docker.com/t/automated-build-raspberry-pi-based-image-on-docker-hub/4155/7
it cannot be used as a source for auto-build on Docker Hub or Docker Store because the base image is for ARM architecture.

setting.js contains a default admin password which is : Gaga-2017
Please change it locally using node-red-admin hash-pw
as well as templates to leverage Twitter and Github WebSSO

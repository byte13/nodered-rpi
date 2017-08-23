# nodered-rpi
NodeRED on Raspbian (Raspberry Pi - ARMv7l platform)

This Docker file adds NodeJS on top of byte13/rpi-raspbian-nodejs:6.11.2.

It possiby updates the base image and utilities.

According to https://forums.docker.com/t/automated-build-raspberry-pi-based-image-on-docker-hub/4155/7
it cannot be used as a source for auto-build on Docker Hub or Docker Store because 
the base image is for ARM architecture.

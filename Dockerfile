# References :
# https://flows.nodered.org/node/node-red-contrib-gpio
# https://raspberrypi.stackexchange.com/questions/48303/install-nodejs-for-all-raspberry-pi#48313
# https://nodered.org/docs/hardware/raspberrypi
#FROM resin/rpi-raspbian:latest
FROM byte13/rpi-raspbian-nodejs:8.9.4

# Install usefull utilities
RUN apt-get update && \
    apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils curl wget sudo unzip iproute2 iputils-ping dnsutils net-tools nmap build-essential python-rpi.gpio python-picamera git

# 
# If the base image is resin/rpi-raspbian:latest, install NodeJS from ARM tarball
#
# RUN cd /tmp
# RUN https://nodejs.org/dist/v8.4.0/node-v8.4.0-linux-armv7l.tar.xz && tar xvf node-v8.4.0-linux-armv7l.tar.xz
#RUN wget https://nodejs.org/dist/v6.11.2/node-v6.11.2-linux-armv7l.tar.xz  && tar xvf node-v6.11.2-linux-armv7l.tar.xz
#RUN cd node-v6.11.2-linux-armv7l && cp -R * /usr/local/ && rm -rf node-v6.11.2-linux-armv7l*

#
# Install Node-Red
#
#RUN /bin/bash <(curl -sL https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/update-nodejs-and-nodered)
#
# Install NodeRed modules
#
# Next line as workaround due to some access errors since NodeJS 8
# https://stackoverflow.com/questions/44633419/no-access-permission-error-with-npm-global-install-on-docker-image
# The problem is because while NPM runs globally installed module scripts as 
# the nobody user, which kinds of makes sense, recent versions of NPM started 
# setting the file permissions for node modules to root. As a result module 
# scripts are no longer allowed to create files and directories in their module.
# A simple workaround, which makes sense in a docker environment, is to set 
# the NPM default global user back to root, like so:

RUN npm -g config set user root

#RUN npm install -g openid-connect
RUN npm install -g --unsafe-perm node-red node-red-admin && \
    npm install -g rpi-gpio  && \
    npm install node-red-contrib-gpio && \
    npm install -g node-red/node-red-auth-twitter && \
    npm install -g node-red/node-red-auth-github && \
    npm install -g node-red-contrib-camerapi && \
    npm install -g node-red-dashboard

# Possibly install latest Mosquitto client (for communication over MQTT)
#RUN sudo wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
#    sudo apt-key add mosquitto-repo.gpg.key && \
#    cd /etc/apt/sources.list.d/ && \
#    sudo wget http://repo.mosquitto.org/debian/mosquitto-stretch.list && \
#    sudo apt-get update && \
#    sudo apt-get install mosquitto-clients python-mosquitto 

#
# Settings to activate admin authentication
#
RUN if [ -f /usr/local/lib/node_modules/node-red/settings.js ] ; then mv /usr/local/lib/node_modules/node-red/settings.js /usr/local/lib/node_modules/node-red/settings.js.dist ; fi
COPY settings.js /usr/local/lib/node_modules/node-red/settings.js

# To make sure nrgpio can be invoked with basename (assuming /usr/local/bin is in $PATH)
RUN ln -s /usr/local/lib/node_modules/node-red/nodes/core/hardware/nrgpio /usr/local/bin/nrgpio
RUN ln -s /usr/local/lib/node_modules/node-red/nodes/core/hardware/nrgpio.py /usr/local/bin/nrgpio.py

RUN /usr/sbin/groupadd nodered -g 1234 \ 
    && /usr/sbin/useradd -d /home/nodered -m nodered -u 1234 -g nodered \
    && echo "nodered  ALL=(ALL) NOPASSWD: /usr/bin/python" >>/etc/sudoers

RUN if ! [ -d /vol1 ] ; then mkdir /vol1; chown root:nodered /vol1; chmod 770 /vol1; fi
VOLUME /vol1

USER nodered

# Next section to be updated in case image is run as a Swarm service to me monitored
# HEALTCHECK

# Define what to start by defaut when running the container
ENV NRPORT=7777
#ENTRYPOINT ["/usr/local/bin/node","--max-old-space-size=256","red.js","-p","7777"]
CMD ["/usr/local/bin/node-red-pi","--max-old-space-size=256","-p","7777"]


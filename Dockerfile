# References :
# https://flows.nodered.org/node/node-red-contrib-gpio
# https://raspberrypi.stackexchange.com/questions/48303/install-nodejs-for-all-raspberry-pi#48313
FROM byte13/rpi-raspbian-nodejs:6.11.2 

MAINTAINER admin@byte13.org

# Install NodeJS packages and usefull utilities
RUN apt-get update && \
    apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils curl wget sudo unzip iputils-ping dnsutils net-tools nmap build-essential python-rpi.gpio git

# 
# Install NodeJS from ARM tarball
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
#RUN npm install -g openid-connect
RUN npm install -g --unsafe-perm node-red node-red-admin
RUN npm install -g rpi-gpio 
RUN npm install node-red-contrib-gpio
RUN npm install -g node-red/node-red-auth-twitter
RUN npm install -g node-red/node-red-auth-github

#
# Settings to activate admin authentication
#
RUN if [ -f /usr/local/lib/node_modules/node-red/settings.js ] ; then mv /usr/local/lib/node_modules/node-red/settings.js /usr/local/lib/node_modules/node-red/settings.js.dist ; fi
COPY settings.js /usr/local/lib/node_modules/node-red/settings.js

RUN /usr/sbin/useradd -d /home/nodered -m nodered
USER nodered

# Define what to start by defaut when running the container
ENV NRPORT=7777
#ENTRYPOINT ["/usr/local/bin/node","--max-old-space-size=256","red.js","-p","7777"]
CMD ["/usr/local/bin/node-red-pi","--max-old-space-size=256","-p","7777"]


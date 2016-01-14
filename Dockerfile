FROM ubuntu:trusty

ENV ENKETO_SRC_DIR=/srv/src/enketo-express

################
# apt installs #
################

# Install Node.
ADD https://deb.nodesource.com/setup_4.x /tmp/
RUN bash /tmp/setup_4.x

COPY ./setup/docker/apt_packages.txt ${ENKETO_SRC_DIR}/setup/docker/
WORKDIR ${ENKETO_SRC_DIR}/
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y $(cat setup/docker/apt_packages.txt)
# Non-interactive equivalent of `dpkg-reconfigure -plow unattended-upgrades` (see https://blog.sleeplessbeastie.eu/2015/01/02/how-to-perform-unattended-upgrades/).
RUN cp /usr/share/unattended-upgrades/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

###############################
# Enketo Express Installation #
###############################

RUN npm install -g grunt-cli
COPY ./package.json ${ENKETO_SRC_DIR}/
RUN npm install --production
RUN npm rebuild node-sass

COPY . ${ENKETO_SRC_DIR}
ENV PATH $PATH:${KPI_SRC_DIR}/node_modules/.bin

# Persist the `secrets` directory so the encryption key remains consistent.
RUN mkdir -p ${ENKETO_SRC_DIR}/setup/docker/secrets
VOLUME ${ENKETO_SRC_DIR}/setup/docker/secrets


EXPOSE 8005
CMD /bin/bash ${ENKETO_SRC_DIR}/setup/docker/entrypoint.bash


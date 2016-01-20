FROM phusion/baseimage:latest

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

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Non-interactive equivalent of `dpkg-reconfigure -plow unattended-upgrades` (see https://blog.sleeplessbeastie.eu/2015/01/02/how-to-perform-unattended-upgrades/).
RUN cp /usr/share/unattended-upgrades/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

###############################
# Enketo Express Installation #
###############################

RUN npm install -g grunt-cli pm2
COPY ./package.json ${ENKETO_SRC_DIR}/
RUN npm install --production

COPY . ${ENKETO_SRC_DIR}
ENV PATH $PATH:${KPI_SRC_DIR}/node_modules/.bin

# Persist the `secrets` directory so the encryption key remains consistent.
RUN mkdir -p ${ENKETO_SRC_DIR}/setup/docker/secrets
VOLUME ${ENKETO_SRC_DIR}/setup/docker/secrets

# Prepare for execution.
COPY ./setup/docker/setup_enketo.bash /etc/my_init.d/
RUN mkdir -p /etc/service/enketo
COPY ./setup/docker/run_enketo.bash /etc/service/enketo/run


EXPOSE 8005

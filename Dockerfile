FROM ubuntu:trusty

EXPOSE 8005
ENTRYPOINT ["bash", "docker_entrypoint.bash"]

####################
# apt-get installs #
####################

WORKDIR /srv
RUN apt-get update && \
    apt-get upgrade -y
RUN apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_0.10 | bash -
COPY apt_packages.txt .
RUN apt-get install -y $(cat apt_packages.txt)
# Non-interactive equivalent of `dpkg-reconfigure -plow unattended-upgrades` (see https://blog.sleeplessbeastie.eu/2015/01/02/how-to-perform-unattended-upgrades/).
RUN cp /usr/share/unattended-upgrades/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

################
# install node #
################

RUN npm install -g grunt-cli pm2

###############################
# Enketo Express Installation #
###############################

# Checks out a fresh copy of the repo.
RUN git clone https://github.com/enketo/enketo-express.git
WORKDIR /srv/enketo-express
RUN npm cache clean &&\
    npm install

# Persist the `secrets` directory so the encryption key remains consistent.
VOLUME /srv/enketo-express/secrets

# FIXME: Manually copy over these files right now since they're not yet in the `master` branch.
COPY create_config.py .
COPY docker_entrypoint.bash .

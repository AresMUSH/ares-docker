FROM ubuntu:20.04
SHELL ["/bin/bash", "-lc"]

EXPOSE 4200
EXPOSE 4201
EXPOSE 4202
EXPOSE 4203

# #########################################################################################
# Updating Ubuntu packages.

RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN apt-get -y install dialog apt-utils
RUN apt-get -y -o Dpkg::Options::="--force-confnew" upgrade

RUN add-apt-repository -y ppa:chris-lea/redis-server
RUN apt-get -y update

# #########################################################################################
# Installing SSL/HTTPS utils.

RUN apt-get install -y binutils
RUN apt-get install -y apt-transport-https

# #########################################################################################
# Installing Git

RUN apt-get install -y git

# #########################################################################################
# Install gem bundler for dependencies and ruby dev for local gems.

RUN apt-get install -y ruby-bundler
RUN apt-get install -y ruby-dev

# #########################################################################################
# Redis DB and nginx for web server

RUN apt-get install -y nginx
RUN apt-get install -y redis-server


# #########################################################################################
# Dependency mgmt for ember cli"

RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN apt-get install -y python
RUN npm install -g npm


# #########################################################################################
# Protect SSH from multiple failed logins."

RUN apt-get install -y fail2ban

# #########################################################################################
# Allow unattended upgrades"

RUN apt-get install -y unattended-upgrades

# #########################################################################################
# Turn unatteded upgrades on."

RUN dpkg-reconfigure -f noninteractive unattended-upgrades

# #########################################################################################
# Create an ares user"
# Ares user password will either be passed in as an arg, or we'll default it

RUN RANDOMPW=$(openssl rand 1000 | strings | grep -io [[:alnum:]] | head -n 16 | tr -d '\n')
RUN PASSWD=${1:-$RANDOMPW}
RUN ENCRYPTEDPW=$(openssl passwd -1 "$PASSWD")
RUN export ARES_USERNAME="ares"
RUN adduser --disabled-password --gecos "" ares
RUN usermod -p "$ENCRYPTEDPW" ares

# Add them to groups

RUN addgroup www
RUN usermod -a -G sudo,www,redis ares

# #########################################################################################
# Give ares user access to www

RUN chown ares /var/www/html
RUN chgrp www /etc/nginx/sites-available/default
RUN chmod g+rwx /etc/nginx/sites-available/default

# #########################################################################################
# RVM needs some libs."

RUN apt-get -y update
RUN apt-get install -y autoconf automake bison libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool libyaml-dev pkg-config sqlite3 zlib1g-dev libreadline-dev libssl-dev curl gawk

# #########################################################################################
# Set up placeholder volumes

RUN mkdir /ares
RUN mkdir /ares/aresmush
RUN mkdir /ares/ares-webportal
RUN mkdir /ares/ares-webportal/node_modules

RUN chown -R ares /ares

# #########################################################################################
# Install RVM."

USER ares
SHELL ["/bin/bash", "-lic"]

RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -

RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby --autolibs=read-fail
RUN source "/home/ares/.rvm/scripts/rvm" & rvm install ruby-3.1.2
RUN source "/home/ares/.rvm/scripts/rvm" & rvm use ruby-3.1.2


# #########################################################################################
# Install Ruby version."

RUN /bin/bash -lc "rvm install ruby-3.1.2"
RUN /bin/bash -lc "rvm use ruby-3.1.2"
RUN echo "source /home/ares/.rvm/scripts/rvm" >> "/home/ares/.profile"
RUN echo "rvm use 3.1.2" >> "/home/ares/.profile"


# #########################################################################################
# Install gem bundler for dependencies."

RUN /bin/bash -lc "gem install bundler"
RUN /bin/bash -lc "gem install rake"

# #########################################################################################
# Installing Node for Ember."

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash\
    && . /home/ares/.nvm/nvm.sh \
    && nvm install 18 \
    && nvm use 18 \
    && nvm alias default 18 \
    && npm install -g ember-cli@4.12
    
FROM ubuntu:19.04

LABEL maintainer="Yevgenii Yolkin <e.v.yolkin@gmail.com>"

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG WORK_DIR=/app

RUN userdel -f www-data &&\
    if getent group www-data ; then groupdel www-data; fi &&\
    groupadd -g ${GROUP_ID} www-data &&\
    useradd -l -u ${USER_ID} -p www-data -g www-data www-data -s /bin/bash &&\
    install -d -m 0755 -o www-data -g www-data /home/www-data

RUN apt-get update
RUN apt-get install -y \
    sudo \
    vim \
    autoconf \
    autogen \
    language-pack-en-base \
    wget \
    zip \
    unzip \
    curl \
    rsync \
    ssh \
    openssh-client \
    git \
    build-essential \
    apt-utils \
    software-properties-common \
    nasm \
    libjpeg-dev \
    libpng-dev \
    mc \
    tmux \
    htop \
    mysql-client \
    libpng16-16

#############
# install php
##############
ARG PHP_VERSION=7.4

RUN apt-get install software-properties-common
RUN add-apt-repository ppa:ondrej/php && apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      php${PHP_VERSION} \
      php${PHP_VERSION}-curl \
      php${PHP_VERSION}-gd \
      php${PHP_VERSION}-dev \
      php${PHP_VERSION}-xml \
      php${PHP_VERSION}-bcmath \
      php${PHP_VERSION}-pdo \
      php${PHP_VERSION}-mysql \
      php${PHP_VERSION}-pgsql \
      php${PHP_VERSION}-mbstring \
      php${PHP_VERSION}-zip \
      php${PHP_VERSION}-bz2 \
      php${PHP_VERSION}-sqlite \
      php${PHP_VERSION}-soap \
      php${PHP_VERSION}-json \
      php${PHP_VERSION}-intl \
      php${PHP_VERSION}-imap \
      php${PHP_VERSION}-imagick \
      php${PHP_VERSION}-xdebug \
      php-xml \
      php-memcached

RUN php -v
# Install composer
RUN curl -sS https://getcomposer.org/installer | php

RUN mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer self-update --preview
RUN command -v composer

## Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs -y
RUN npm install npm -g
RUN npm install yarn -g
RUN command -v node
RUN command -v npm

# config git
ARG GIT_USER_NAME="Yevgenii Yolkin"
ARG GIT_USER_EMAIL="e.v.yolkin@gmail.com"

RUN git config --global user.name ${GIT_USER_NAME}
RUN git config --global user.email ${GIT_USER_EMAIL}

RUN mkdir ${WORK_DIR} && chown -R www-data:www-data ${WORK_DIR}

WORKDIR /app
USER www-data
CMD ["bash"]
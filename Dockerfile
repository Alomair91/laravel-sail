FROM ubuntu:22.04

LABEL maintainer="Taylor Otwell"

ARG WWWGROUP
ARG NODE_VERSION=20
ARG POSTGRES_VERSION=15

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN mkdir -p /etc/apt/keyrings
RUN apt-get install -y gnupg
RUN apt-get install -y gosu
RUN apt-get install -y curl
RUN apt-get install -y ca-certificates
RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt-get install -y git
#RUN apt-get install -y supervisor
RUN apt-get install -y sqlite3
RUN apt-get install -y libcap2-bin
RUN apt-get install -y libpng-dev
RUN apt-get install -y python2
RUN apt-get install -y dnsutils
RUN apt-get install -y librsvg2-bin
RUN apt-get install -y fswatch
RUN curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /etc/apt/keyrings/ppa_ondrej_php.gpg > /dev/null
RUN echo "deb [signed-by=/etc/apt/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list
RUN apt-get update

RUN apt-get install -y php8.2-cli php8.2-dev
RUN #apt-get install -y php aphp8.2-pgsql
RUN apt-get install -y php8.2-sqlite3
RUN apt-get install -y php8.2-gd
RUN apt-get install -y php8.2-imagick
RUN apt-get install -y php8.2-curl
RUN apt-get install -y php8.2-imap php8.2-mysql php8.2-mbstring
RUN apt-get install -y php8.2-xml php8.2-zip php8.2-bcmath php8.2-soap
RUN apt-get install -y php8.2-intl php8.2-readline
RUN apt-get install -y php8.2-ldap
RUN apt-get install -y php8.2-msgpack php8.2-igbinary php8.2-redis php8.2-swoole
RUN apt-get install -y php8.2-memcached php8.2-pcov php8.2-xdebug

# Install Composer globally
# copy composer from local to the docker image on the server
#COPY --from=composer:2.2.6 /usr/bin/composer /usr/bin/composer
RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x nodistro main" > /etc/apt/sources.list.d/nodesource.list

#RUN #apt-get update \
#    && apt-get install -y nodejs \
#    && npm install -g npm \
#    && npm install -g pnpm \
#    && npm install -g bun \
#    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /etc/apt/keyrings/yarn.gpg >/dev/null \
#    && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
#    && curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/keyrings/pgdg.gpg >/dev/null \
#    && echo "deb [signed-by=/etc/apt/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update
RUN #apt-get install -y yarn
RUN apt-get install -y mysql-client
RUN #apt-get install -y postgresql-client-$POSTGRES_VERSION
RUN apt-get -y autoremove
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.2

RUN groupadd --force -g $WWWGROUP sail
RUN useradd -ms /bin/bash --no-user-group -g $WWWGROUP -u 1337 sail

COPY ./docker/start-container /usr/local/bin/start-container
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./docker/php.ini /etc/php/8.2/cli/conf.d/99-sail.ini
RUN chmod +x /usr/local/bin/start-container

EXPOSE 8000

ENTRYPOINT ["start-container"]

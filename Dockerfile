FROM debian:buster-slim
LABEL maintainer="Travis Merrill"

##Environment vairiables
ENV ASTERISK_VERSION=17.9.4 \
    FREEPBX_VERSION=14
RUN whoami
##initial update
RUN apt-get update && apt-get upgrade -y && \
    apt-get install gnupg2 -y && \
    wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.x.list && \
    apt-get update && \
    apt-get install -y build-essential linux-headers-`uname -r` openssh-server apache2 mariadb-server \
      mariadb-client bison flex php7.4 php7.4-curl php7.4-cli php7.4-common php7.4-mysql php7.4-gd php7.4-mbstring \
      php7.4-intl php7.4-xml php-pear curl sox libncurses5-dev libssl-dev mpg123 libxml2-dev libnewt-dev sqlite3 \
      libsqlite3-dev pkg-config automake libtool autoconf git unixodbc-dev uuid uuid-dev \
      libasound2-dev libogg-dev libvorbis-dev libicu-dev libcurl4-openssl-dev libical-dev libneon27-dev libsrtp2-dev \
      libspandsp-dev subversion libtool-bin python-dev unixodbc dirmngr sendmail-bin sendmail && \
    curl -sL https://deb.nodesource.com/setup_14.x | -E bash - && \
    apt-get install -y nodejs
    
## testing s6 overlay
ARG S6_OVERLAY_VERSION=3.1.0.1
RUN apt-get update && apt-get install -y nginx xz-utils
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
CMD ["/usr/sbin/nginx"]

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ENTRYPOINT ["/init"]

FROM ubuntu:focal

LABEL org.opencontainers.image.authors="Lifeismana"

ARG ZULU_REPO_VER=1.0.0-2

# SPIGOT_HOME         default directory for SPIGOT-server
# SPIGOT_VER          default minecraft version to compile
# SPIGOT_AUTORESTART  set to yes to restart if minecraft stop command is executed
ENV SPIGOT_HOME=/minecraft \
    SPIGOT_VER=latest \
    SPIGOT_AUTORESTART=yes \
    MC_MAXMEM= \
    MC_MINMEM= \
    OTHER_JAVA_OPS= \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8\
    TZ=Europe/Paris

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install gnupg software-properties-common locales curl wget git jq && \
    locale-gen en_US.UTF-8 && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9 && \
    curl -sLO https://cdn.azul.com/zulu/bin/zulu-repo_${ZULU_REPO_VER}_all.deb && dpkg -i zulu-repo_${ZULU_REPO_VER}_all.deb && \
    apt-get -qq update && \
    apt-get -qq -y dist-upgrade && \
    mkdir -p /usr/share/man/man1 && \
    echo "Package: zulu17-*\nPin: version 17.30+15*\nPin-Priority: 1001" > /etc/apt/preferences && \
    apt-get -qq -y --no-install-recommends install zulu17-jdk=17.0.1-* && \
    apt-get -qq -y purge gnupg software-properties-common curl && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/lists/* zulu-repo_${ZULU_REPO_VER}_all.deb

ENV JAVA_HOME=/usr/lib/jvm/zulu17-ca-amd64



# add extra files needed
COPY rootfs /

RUN /usr/sbin/useradd -s /bin/bash -d /minecraft -m minecraft && \

    sed -i '/en_US.UTF-8/s/^ '

# expose minecraft port
EXPOSE 25565



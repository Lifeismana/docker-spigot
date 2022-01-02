FROM nimmis/ubuntu:20.04

ARG ZULU_REPO_VER=1.0.0-3

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
    apt-get -qq -y --no-install-recommends install zulu17-jdk && \
    apt-get -qq -y purge gnupg software-properties-common && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/lists/* zulu-repo_${ZULU_REPO_VER}_all.deb\
    dpkgArch="$(dpkg --print-architecture)";


ENV JAVA_HOME=/usr/lib/jvm/zulu17-ca-${dpkgArch}

# add extra files needed
COPY rootfs /

RUN /usr/sbin/useradd -s /bin/bash -d /minecraft -m minecraft

# expose minecraft port
EXPOSE 25565



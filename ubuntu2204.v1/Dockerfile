FROM        ubuntu:22.04
MAINTAINER  Wei Zhou <weizhou@apache.org>

ENV         DEBIAN_FRONTEND noninteractive

RUN         apt update -qq && \
            apt upgrade -y && \
            apt-get install -y dpkg-dev python2 python3 debhelper openjdk-11-jdk genisoimage python3-mysql.connector maven lsb-release devscripts python-setuptools python3-setuptools git wget curl

RUN         curl -sL https://deb.nodesource.com/setup_14.x | bash - \
            && apt-get install -y nodejs

COPY        entrypoint.sh /entrypoint.sh

ENTRYPOINT  ["/entrypoint.sh"]

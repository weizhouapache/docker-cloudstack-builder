FROM        oraclelinux:10
MAINTAINER  Wei Zhou <weizhou@apache.org>

RUN         yum install -y which java-21-openjdk java-21-openjdk-devel maven rpm-build \
            && yum install -y gcc glibc-devel python3 python3-pip python3-setuptools wget curl git jq xorriso --allowerasing

RUN         curl -sL https://rpm.nodesource.com/setup_20.x | bash - \
            && yum install -y nodejs g++

COPY        entrypoint.sh /entrypoint.sh

ENTRYPOINT  ["/entrypoint.sh"]

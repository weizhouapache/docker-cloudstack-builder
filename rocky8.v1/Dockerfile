FROM        rockylinux:8
MAINTAINER  Wei Zhou <weizhou@apache.org>

RUN         yum install -y which mlocate java-11-openjdk java-11-openjdk-devel maven rpm-build \
            && yum install -y gcc glibc-devel mkisofs python2 python3 python3-pip python3-setuptools wget curl \
            && alternatives --set java java-11-openjdk.x86_64 \
            && alternatives --set javac java-11-openjdk.x86_64 \
            && alternatives --set python /usr/bin/python3

RUN         curl -sL https://rpm.nodesource.com/setup_14.x | bash - \
            && yum install -y nodejs

RUN         yum install -y git

COPY        entrypoint.sh /entrypoint.sh

ENTRYPOINT  ["/entrypoint.sh"]

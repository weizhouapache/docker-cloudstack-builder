FROM        rockylinux:9
MAINTAINER  Wei Zhou <weizhou@apache.org>

RUN         yum install -y which mlocate java-17-openjdk java-17-openjdk-devel maven rpm-build \
            && yum install -y gcc glibc-devel mkisofs python3 python3-pip python3-setuptools wget curl git jq --allowerasing \
            && alternatives --set java java-17-openjdk.x86_64 \
            && alternatives --set javac java-17-openjdk.x86_64

RUN         curl -sL https://rpm.nodesource.com/setup_20.x | bash - \
            && yum install -y nodejs g++

COPY        entrypoint.sh /entrypoint.sh

ENTRYPOINT  ["/entrypoint.sh"]

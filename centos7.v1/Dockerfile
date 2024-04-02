FROM        centos:centos7
MAINTAINER  Wei Zhou <weizhou@apache.org>

RUN         yum install -y which mlocate java-11-openjdk java-11-openjdk-devel maven rpm-build \
            && yum install -y ws-commons-util gcc glibc-devel mkisofs python-setuptools python3 python3-pip python3-setuptools wget curl git \
            && update-alternatives --set java java-11-openjdk.x86_64 \
            && update-alternatives --set javac java-11-openjdk.x86_64 \
            && wget https://cdn.mysql.com/archives/mysql-connector-python-2.1/mysql-connector-python-2.1.7-1.el7.x86_64.rpm \
            && rpm -ivh mysql-connector-python-2.1.7-1.el7.x86_64.rpm

RUN         curl -sL https://rpm.nodesource.com/setup_14.x | bash - \
            && yum install -y nodejs

COPY        entrypoint.sh /entrypoint.sh

ENTRYPOINT  ["/entrypoint.sh"]

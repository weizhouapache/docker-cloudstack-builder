#!/bin/bash -x

# Print system information
mvn -version
java --version
javac -version

SOURCE_DIR=/source/
OUTPUT_DIR=/output/
BUILD_OPTS_DEFAULT="-Dnoredist -DskipTests -Dsystemvm-kvm -Dsystemvm-xen -Dsystemvm-vmware -T2"

SOURCE=${SOURCE:-}
VERSION=${VERSION:-}
BUILD_OPTS=${BUILD_OPTS:-$BUILD_OPTS_DEFAULT}

if [[ $SOURCE =~ http.* ]] || [[ $SOURCE =~ git.* ]]; then
    if [ -d "$SOURCE_DIR" ]; then
        echo "$SOURCE_DIR already exists in the container"
        exit 1
    fi
    git clone $SOURCE $SOURCE_DIR
elif [ -z "$SOURCE_DIR" ] || [ ! -d "$SOURCE_DIR" ] || [ ! -f "$SOURCE_DIR/pom.xml" ]; then
    echo "Source $SOURCE_DIR does not exist in the container"
    exit 1
fi
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "$OUTPUT_DIR does not exist in the container"
    exit 1
fi

cd $SOURCE_DIR
if [ ! -z "$VERSION" ]; then
    git checkout $VERSION
fi

# Packaging
NODE_OPTIONS=--openssl-legacy-provider ACS_BUILD_OPTS=$BUILD_OPTS packaging/build-deb.sh

mv $SOURCE_DIR/../cloudstack-*.deb $OUTPUT_DIR
if [[ $SOURCE =~ http.* ]] || [[ $SOURCE =~ git.* ]]; then
    rm -rf $SOURCE_DIR
fi

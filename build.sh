#!/bin/bash

usage() {
  printf "Usage: $0
          -r    <the repository of the image. Default is weizhouapache/cloudstack-builder>
          -i    <the name of the image>
          -s    <the source directory or git repository>
          -o    <the output directory>
          -v    <the CloudStack version, branch name or commit SHA>
          -b    <the build options>
          -u    # use sudo
          -c    <the name of config file which includes all settings above>
          -d    # dry-run
          -h    # help message\n"
  exit 1
}

REPO="weizhouapache/cloudstack-builder"
SUDO=

while getopts r:i:s:o:v:b:uc:dh OPT
do
    case "$OPT" in
      r)  REPO="$OPTARG";;
      i)  IMAGE="$OPTARG";;
      s)  SOURCE="$OPTARG";;
      o)  OUTPUT="$OPTARG";;
      v)  VERSION="$OPTARG";;
      b)  BUILD_OPTS="$OPTARG";;
      u)  SUDO="sudo";;
      c)  CONFIG="$OPTARG";;
      d)  DRY_RUN="yes";;
      h)  usage
          exit 0;;
      *)  # UNKNOWN
          usage
          exit 1;;
    esac
done

if [ ! -z $CONFIG ]; then
    source $CONFIG
fi

if [ -z $SOURCE ] || [ -z $IMAGE ] || [ -z $OUTPUT ]; then
    echo "The image name, source and output directory are required"
    usage
fi

FULL_IMAGE=$REPO:$IMAGE
echo "Using image: $FULL_IMAGE"
echo "Using source: $SOURCE"
echo "Using output: $OUTPUT"
echo "Using version: $VERSION"
echo "Using build options: \"$BUILD_OPTS\""
echo "Using sudo: $SUDO"
echo ""

CONTAINER_NAME="cloudstack-builder-$(echo $RANDOM | tr '[0-9]' '[a-z]')"
COMMAND="$SUDO docker run -ti --name $CONTAINER_NAME"

# Using local maven cache
MAVEN_CACHE=$($SUDO readlink -f ~/.m2/)
$SUDO mkdir -p $MAVEN_CACHE
COMMAND="$COMMAND -v $MAVEN_CACHE:/root/.m2/"

if [ -d $SOURCE ]; then
    COMMAND="$COMMAND -v ${SOURCE}:/source/"
else
    COMMAND="$COMMAND --env SOURCE=${SOURCE}"
fi
if [ ! -z $OUTPUT ]; then
    $SUDO mkdir -p ${OUTPUT}
    COMMAND="$COMMAND -v ${OUTPUT}:/output/"
fi
if [ ! -z $VERSION ]; then
    COMMAND="$COMMAND --env VERSION=${VERSION}"
fi
if [ ! -z "$BUILD_OPTS" ]; then
    export BUILD_OPTS=$BUILD_OPTS
    COMMAND="$COMMAND --env BUILD_OPTS"
fi
COMMAND="$COMMAND $FULL_IMAGE"

if [ "$DRY_RUN" = "yes" ];then
    echo "COMMAND is: ${COMMAND}"
else
    echo "Running command: ${COMMAND}"
    ${COMMAND}
    $SUDO docker rm $CONTAINER_NAME
fi

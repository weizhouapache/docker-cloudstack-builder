# docker-cloudstack-builder

This repository maintains the Dockerfile and scripts to build Apache CloudStack in docker images.

## Compatibility matrix

| **Dockerfile**      |   **CloudStack versions**     |  **Note**            |
|---------------------|-------------------------------|----------------------|
| ubuntu2204.v1       | 4.18.x, 4.19.x                | For Ubuntu distros   |
| rocky8.v1           | 4.18.x, 4.19.x                | For RHEL/Rocky Linux/AlmaLinux/OracleLinux distros   |

## Usage

### (Optional) Build docker image 

The pre-built image can be found at https://hub.docker.com/repository/docker/weizhouapache/cloudstack-builder

```
cd ubuntu2204.v1
docker build -f Dockerfile -t weizhouapache/cloudstack-builder:ubuntu2204.v1 .
```

### 1. Build packages with configuration file

```
./build.sh -c <configuration file name>
```

Below are configurations in the configuration file.

| **Variablies**      |   **Description**             |  **Note**            |
|---------------------|-------------------------------|----------------------|
| `SOURCE`            |  The directory where the source code is, or the URL of the git repository.      | Mounted to /source/ if it is a directory. |
| `OUTPUT`            |  The directory where the packages will be in.        | Mounted to /output/ in the docker container. |
| `SUDO`              |  Please set to `sudo` if you use a non-root user     | Default: None.  |
| `VERSION`           |  The CloudStack version, branch name or commit SHA   | Default: None.  |
| `BUILD_OPTS`        |  The build options. Refer to `Build Options`         | Default: None.  |

A sample of environment variables can be found at `config.ubuntu.sample`.

### 2. Build packages with parameters

```
Usage: ./build.sh
          -r    <the repository of the image. Default is weizhouapache/cloudstack-builder>
          -i    <the name of the image>
          -s    <the source directory or git repository>
          -o    <the output directory>
          -v    <the CloudStack version, branch name or commit SHA>
          -b    <the build options>
          -u    # use sudo
          -c    <the name of config file which includes all settings above>
          -d    # dry-run
          -h    # help message
```

Examples
```
# Build from a local directory
./build.sh -i ubuntu2204.v1 -s /data/cloudstack -o /tmp -b "-Dnoredist -DskipTests -Dsystemvm-kvm -Dsystemvm-xen -Dsystemvm-vmware"

# Build from git repository
./build.sh -i ubuntu2204.v1 -s https://github.com/apache/cloudstack.git -o /tmp -v main -b "-Dnoredist -DskipTests -Dsystemvm-kvm -Dsystemvm-xen -Dsystemvm-vmware" -u
```

### 3. Build packages by `docker` command

An example how to build packages from local directory
```
SUDO=
SOURCE=./
OUTPUT=/tmp/
CONTAINER_NAME="cloudstack-builder-$(echo $RANDOM | tr '[0-9]' '[a-z]')"

$SUDO mkdir -p ~/.m2/
$SUDO mkdir -p ${OUTPUT}
$SUDO docker run -ti \
    -n $CONTAINER_NAME \
    -v ~/.m2:/root/.m2/ \
    -v ${SOURCE}:/source/ \
    -v ${OUTPUT}:/output/ \
    --env BUILD_OPTS="-Dnoredist -DskipTests -Dsystemvm-kvm -Dsystemvm-xen -Dsystemvm-vmware" \
    weizhouapache/cloudstack-builder:ubuntu2204.v1
```

An example how to build packages from git repository

```
SUDO=
SOURCE=https://github.com/apache/cloudstack.git
VERSION=4.19.0.0
OUTPUT=/tmp/
BUILD_OPTS="-Dnoredist -DskipTests -Dsystemvm-kvm -Dsystemvm-xen -Dsystemvm-vmware"
CONTAINER_NAME="cloudstack-builder-$(echo $RANDOM | tr '[0-9]' '[a-z]')"

$SUDO mkdir -p ~/.m2/
$SUDO mkdir -p ${OUTPUT}
$SUDO docker run -ti \
    -n $CONTAINER_NAME \
    -v ~/.m2:/root/.m2/ \
    -v ${OUTPUT}:/output/ \
    -e SOURCE \
    -e OUTPUT \
    -e BUILD_OPTS \
    weizhouapache/cloudstack-builder:ubuntu2204.v1
```
## Build Options

| **OS**      |   **Option**       |  **Note**            |
|-------------|--------------------|----------------------|
| Ubuntu      | -Dnoredist         | Support non-Open Source Software (e.g. VMware) |
|             | -DskipTests        | Skip unit tests      |
|             | -Dsystemvm-kvm     | Bundle with SystemVM template for KVM |
|             | -Dsystemvm-vmware  | Bundle with SystemVM template for VMware |
|             | -Dsystemvm-xen     | Bundle with SystemVM template for XenServer/XCP-ng |


The default value for ubuntu images is `-Dnoredist -DskipTests -Dsystemvm-kvm -Dsystemvm-xen -Dsystemvm-vmware`

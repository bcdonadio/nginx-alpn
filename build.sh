#!

set -e
BUILDS="el7 el6 el5"

for distro in $BUILDS; do
    docker build -t nginx-$distro -f Dockerfile-$distro .
    docker rm -f nginx-$distro || true 2>/dev/null
    docker run \
        -d \
        --name nginx-$distro \
        nginx-$distro \
        /bin/bash \
        /docker-entrypoint.sh
    docker cp nginx-$distro:/home/builder/rpmbuild/RPMS ./
    docker kill nginx-$distro
done


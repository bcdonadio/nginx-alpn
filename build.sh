#!

set -e
BUILDS="el7 el6"

for distro in $BUILDS; do
    docker build -t nginx-$distro -f Dockerfile-$distro .
    docker rm -f nginx-$distro || true 2>/dev/null
    docker run \
        -d \
        --name nginx-$distro \
        nginx-$distro \
        /bin/bash \
        /docker-entrypoint.sh
    sleep 2
    docker cp nginx-$distro:/home/builder/rpmbuild/RPMS ./
    docker kill nginx-$distro
done


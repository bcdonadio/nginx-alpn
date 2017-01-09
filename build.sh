#!/bin/bash
source common.sh

for build in $builds; do
    dockerName="$namespace--$build"
    docker build -t $dockerName \
        -f "$HOST_RECIPEDIR/$build.dockerfile" .

    # Docker needs for the container to be running in order to copy things from
    # the image itself
    docker rm -f $dockerName &>/dev/null || true # Remove old instance
    docker run \
        -d \
        --name $dockerName \
        $dockerName \
        /bin/bash \
        /docker-entrypoint.sh

    # Contents will be merged with previous builds
    mkdir -p "$HOST_OBJDIR/RPMS"
    docker cp "$dockerName:$DOCKER_OBJPREFIX/RPMS" "$HOST_OBJDIR/"
    mkdir -p "$HOST_OBJDIR/SRPMS"
    docker cp "$dockerName:$DOCKER_OBJPREFIX/SRPMS" "$HOST_OBJDIR/"

    # Delete the instance (not the image)
    docker kill $dockerName
done


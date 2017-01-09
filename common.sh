#!/bin/bash
set -e

REPO="nginx-alpn/mainline"
DIST="el"
VERSIONS="7 6"

HOST_RECIPEDIR="recipes"
HOST_OBJDIR="build"

DOCKER_OBJPREFIX="/home/builder/rpmbuild"

namespace="$( echo "$REPO" | sed -e 's!/!--!g' )"
objDirList="$DOCKER_RPMDIR $DOCKER_SRPMDIR"

for version in $VERSIONS; do
    builds+="${DIST}${version} "
done



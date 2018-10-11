#!/bin/bash
source common.sh

fileList="$( find "$HOST_OBJDIR" -type f -iname '*.rpm' )"

for file in $fileList; do
    fileName="$( basename "$file" )"
    distVersion="$( echo "$fileName" | grep -Po ".*${DIST}\K([0-9])" )"

    basename="$(basename $file)"
    if [ $? -eq 0 ]; then
        package_cloud yank "$REPO/$DIST/$distVersion" $basename
    fi
done


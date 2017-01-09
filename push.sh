#!/bin/bash
source common.sh

fileList="$( find "$HOST_OBJDIR" -type f -iname '*.rpm' )"

for file in $fileList; do
    fileName="$( basename "$file" )"
    distVersion="$( echo "$fileName" | grep -Po ".*${DIST}\K([0-9])" )"

    # Only push correctly signed packages
    rpm -K "$file"
    if [ $? -eq 0 ]; then
        package_cloud push "$REPO/$DIST/$distVersion" "$file" || true
    fi
done


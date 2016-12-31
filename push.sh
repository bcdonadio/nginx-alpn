#!/bin/bash

REPO="nginx-alpn-el/nginx"

fileList="$( find RPMS/ -type f -iname "*.rpm" )"

for file in $fileList; do
    rpm -K "$file"
    if [ $? -eq 0 ]; then
        el="$( echo "$file" | grep -Po '.*el\K([0-9])' )"
        package_cloud push $REPO/el/$el "$file"
    fi
done


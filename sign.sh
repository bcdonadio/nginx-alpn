#!/bin/bash

find RPMS/ -type f -iname "*.rpm" -exec rpmsign --addsign "{}" \;


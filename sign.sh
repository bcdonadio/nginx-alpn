#!/bin/bash
source common.sh

find "$HOST_OBJDIR" -type f -iname "*.rpm" -exec rpmsign --addsign "{}" \;


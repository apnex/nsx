#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

RTNAME=$1
RTTYPE=$2
${WORKDIR}/drv.logical-routers.create.sh "$1" "$2"

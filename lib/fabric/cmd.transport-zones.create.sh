#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

TZNAME=$1
TZSWITCH=$2
TZTYPE=$3
${WORKDIR}/drv.transport-zones.create.sh "$1" "$2" "$3"
